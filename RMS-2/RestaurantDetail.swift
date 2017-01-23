//
//  RestaurantDetailViewController.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Font_Awesome_Swift


class RestaurantDetail: UIViewController {

    var restaurant : Restaurants!
    var interactor : Interactor? = nil
    
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var imageView : UIImageView!
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
        customize()
        configureImageView(url: restaurant.img!)
        configureTitleLb(title: restaurant.title!)
        configureDescLb(desc: restaurant.desc!)
    }
    
    private func customize(){
        backBtn.setFAIcon(icon: FAType.FAAngleLeft, forState: .normal)
        firstLineBtn.setFAIcon(icon: FAType.FAMapMarker, forState: .normal)
        secondLineBtn.setFAIcon(icon: FAType.FAClockO, forState: .normal)
        thirdLineBtn.setFAIcon(icon: FAType.FAPhone, forState: .normal)
        firstLineBtn.setFATitleColor(color: .black, forState: .normal)
        secondLineBtn.setFATitleColor(color: .black, forState: .normal)
        thirdLineBtn.setFATitleColor(color: .black, forState: .normal)
    }
    
    private func configureDescLb(desc : String){
        descLb.text = desc
        descLb.sizeToFit()
    }

    private func configureTitleLb(title : String){
        titleLb.text = title
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
