//
//  QRButton.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import FacebookLogin
import FBSDKLoginKit

protocol QRButtonDelegate {
    func qrBtnClicked(sender : UIButton)
}

extension QRButtonDelegate where Self : UITabBarController {
    func qrBtnClicked(sender : UIButton) {
        performSegue(withIdentifier: "MainOrder", sender: nil)
    }
}

class QRButton: UIButton{

    var delegate : QRButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(qrBtnClicked(_:)), for: .touchUpInside)
        self.setImage(UIImage.init(named: "QR Code")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = .white
        self.backgroundColor = Color.lightBlue.base
        NotificationCenter.default.addObserver(self, selector: #selector(hideSelf(notification:)), name: Notification.Name("hideQRButton"), object: nil)
    }
    
    func qrBtnClicked(_ sender : UIButton){
        delegate?.qrBtnClicked(sender: sender)
    }
    
    func hideSelf(notification : Notification){
        let state = notification.object as! Bool
        if(state) {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
            })
        }else{
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                self.transform = .identity
            }, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
