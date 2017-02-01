//
//  RestaurantDetailViewController.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import Alamofire


class RestaurantDetail: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var restaurant : Restaurants!
    var interactor : Interactor? = nil
    private var imgList : [String]! = []
    
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var titleLb : UILabel!
    @IBOutlet weak var descLb : UILabel!
    @IBOutlet weak var firstLineBtn: UIButton!
    @IBOutlet weak var firstLineLb: UILabel!
    @IBOutlet weak var secondLineBtn: UIButton!
    @IBOutlet weak var secondLineLb: UILabel!
    @IBOutlet weak var thirdLineBtn: UIButton!
    @IBOutlet weak var thirdLineLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAlamofire(dowloadComlete: { _ in
            self.collectionView.reloadData()
        })
        customize()
        configureTitleLb(title: restaurant.title!)
        configureDescLb(desc: restaurant.desc!)
    }
    
    private func customize(){
        backBtn.setFAIcon(icon: FAType.FAChevronLeft, forState: .normal)
        firstLineBtn.setFAIcon(icon: FAType.FAMapMarker, forState: .normal)
        secondLineBtn.setFAIcon(icon: FAType.FAClockO, forState: .normal)
        thirdLineBtn.setFAIcon(icon: FAType.FAPhone, forState: .normal)
        firstLineBtn.setFATitleColor(color: .black, forState: .normal)
        secondLineBtn.setFATitleColor(color: .black, forState: .normal)
        thirdLineBtn.setFATitleColor(color: .black, forState: .normal)
        
    }
    
    private func configureAlamofire(dowloadComlete : @escaping DowloadImgComplete){
        Alamofire.request("\(_urlBase)Menu").responseJSON{ response in
            if(response.result.isFailure) {return}
            let data = response.result.value as! [String:AnyObject]
            for item in data.values {
                self.imgList.append(item["menu_img"] as! String)
            }
            dowloadComlete(self.imgList)
        }
    }
    
    private func configureDescLb(desc : String){
        descLb.text = desc
        descLb.sizeToFit()
    }

    private func configureTitleLb(title : String){
        titleLb.text = title
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RestaurantDetailCell
        cell.configureCell(url: (indexPath.row == 0 ? restaurant.img! : imgList[indexPath.row - 1]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func openMap(_ sender: UIButton) {
        prepareToOpenMap(latitude: "13.6188287", longtitude: "100.6734406",title: "ซอยอัมพร")
    }
    
    @IBAction func openTime(_ sender: UIButton) {
    }

    @IBAction func openPhone(_ sender: UIButton) {
        if let url  = NSURL.init(string: "tel://\("0614219900")"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func dismissDetail(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func DismissHandler(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.4
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard  let interactor = interactor else {return}
        switch sender.state {
        case .began:
            interactor.hasStart = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStart = false
            interactor.cancel()
        case .ended:
            interactor.hasStart = false
            (interactor.shouldFinish ? interactor.finish() : interactor.cancel())
        default:
            break
        }
    }
}

class RestaurantDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView : UIImageView!
    
    func configureCell(url : String) {
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
    }
    
}
