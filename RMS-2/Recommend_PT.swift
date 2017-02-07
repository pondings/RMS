//
//  Recommend_PT.swift
//  RMS-2
//
//  Created by Pondz on 1/26/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import Alamofire
import Material

class Recommend_PT: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DataManagentDelegate {

    private var restaurantList : [Dictionary<String,AnyObject>]! = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect.init(origin: CGPoint.init(x: 5, y: 0), size: self.view.frame.size)
        let cv = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = Color.grey.lighten1
        cv.keyboardDismissMode = .onDrag
        cv.register(Recommend_PTCollectionCell.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.grey.lighten1
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.frame.size.height = self.view.frame.height
        collectionView.frame.size.width = self.view.frame.width - 10
        self.view.addSubview(collectionView)
        configureAlamoFire(path: "Restaurant", downloadComplete: { result in
            self.restaurantList = result
            self.collectionView.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Recommend_PTCollectionCell
        cell.configureCell(res: Restaurants.init(restDict: restaurantList[indexPath.row]))
        cell.frame.origin.x = 4
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width - 18, height: self.view.frame.height * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

class Recommend_PTCollectionCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let size = CGSize.init(width: self.frame.width * 0.4, height: self.frame.height)
        let origin = CGPoint.init(x: 0, y: 0)
        let iv = UIImageView.init(frame: CGRect.init(origin: origin, size: size))
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        return iv
    }()
    
    func configureCell(res : Restaurants){
        self.backgroundColor = .white
        self.cornerRadius = 8
        configureImageView(url: res.img!)
    }
    
    private func configureImageView(url : String){
        let urlString = url
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if error != nil {return}
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
            DispatchQueue.main.async {self.imageView.image = UIImage(data: data!)}
        }.resume()
        self.addSubview(imageView)
    }
}
