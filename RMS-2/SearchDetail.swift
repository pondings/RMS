//
//  SearchDetail.swift
//  RMS-2
//
//  Created by Pondz on 1/24/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Alamofire
import Material

class SearchDetail: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var restaurantList : [Dictionary<String,AnyObject>]! = []
    var path : String! = "Restaurant"
    let menu = ["first","second","third","fouth","five","sixth"]

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let yPosition = self.menuCV.frame.maxY + 4
        let height = (self.frame.height - (self.frame.height * 0.1))
        let cv = UICollectionView.init(frame: CGRect.init(x: 0, y: yPosition, width: self.frame.width, height: height), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var menuCV: UICollectionView = {
        let point = CGPoint.init(x: 0, y: 8)
        let size = CGSize.init(width: self.frame.width, height: self.frame.height * 0.07)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView.init(frame: CGRect.init(origin: point, size: size), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = Color.grey.lighten1
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(SearchDetailCollectionCell.self, forCellWithReuseIdentifier: "Cell")
        menuCV.register(SearchDetailMenuCell.self, forCellWithReuseIdentifier: "Cell")
        self.backgroundColor = Color.grey.lighten1
        collectionView.backgroundColor = Color.grey.lighten1
        self.addSubview(menuCV)
        self.addSubview(collectionView)
    }
    
    func searchForResraurant(text : String){
        print(text)
        configureAlamofire {
            self.collectionView.reloadData()
        }
    }
    
    func configureAlamofire(downloadComplete : @escaping DowloadComplete){
        Alamofire.request("\(_urlBase)\(path!)").responseJSON { response in
            if response.result.isFailure {return}
            let data = response.result.value as! [String : AnyObject]
            self.restaurantList.removeAll()
            for item in data.values {
                self.restaurantList.append(item as! Dictionary<String,AnyObject>)
            }
            downloadComplete()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchDetailCollectionCell
            cell.configure(res: Restaurants.init(restDict: restaurantList[indexPath.row]))
            return cell
        }
        let cell = menuCV.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchDetailMenuCell
        cell.configureCell(title: menu[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count : Int!
        if(collectionView == menuCV) { count = menu.count }
        else { count = restaurantList.count }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size : CGSize!
        if(collectionView == menuCV) { size = CGSize.init(width: self.width / 5, height: menuCV.frame.height) }
        else { size = CGSize.init(width: self.frame.width - 20, height: self.frame.height * 0.2) }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == menuCV) { menuCV.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchDetailCollectionCell : UICollectionViewCell {
    
    lazy var cellFrame : CGRect = self.frame
    
    lazy var imageView: UIImageView = {
        let point = CGPoint.init(x: 0, y: 0)
        let size = CGSize.init(width: self.cellFrame.width * 0.4, height: self.cellFrame.height)
        let iv = UIImageView.init(frame: CGRect.init(origin: point, size: size))
        return iv
    }()
    
    func configure(res : Restaurants){
        self.cornerRadius = 8
        self.backgroundColor = .white
        configureImageView(url: res.img!)
    }
    
    private func configureImageView(url : String){
        let urlString = url
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if error != nil {
                print("Failed fetching image:", error!)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }.resume()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        self.addSubview(imageView)
    }
    
}

class SearchDetailMenuCell: UICollectionViewCell {
    
    lazy var titleLb: UILabel = {
        let width = self.frame.width
        let height = self.frame.height
        let xPosition = ((self.frame.width / 2) - (width / 2))
        let yPosition = ((self.frame.height / 2) - (height / 2))
        let lb = UILabel.init(frame: CGRect.init(x: xPosition, y: yPosition, width: width, height: height))
        lb.textAlignment = .center
        return lb
    }()
    
    func configureCell(title : String){
        titleLb.text = title
        self.addSubview(titleLb)
    }
    
}
