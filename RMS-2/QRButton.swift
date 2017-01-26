//
//  QRButton.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material

protocol QRButtonDelegate {
    func qrBtnClicked(sender : UIButton)
}

class QRButton: UIButton {
    
    var delegate : QRButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(qrBtnClicked(_:)), for: .touchUpInside)
        self.setImage(UIImage.init(named: "QR Code")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = .white
        self.backgroundColor = Color.lightBlue.base
    }
    
    func qrBtnClicked(_ sender : UIButton){
        print("QR Button Clicked!")
        delegate?.qrBtnClicked(sender: sender)
        sender.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            sender.transform = .identity
        }, completion: nil)
    }
    
    func hideSelf(isHidden : Bool){
        if(isHidden) {
            UIView.animate(withDuration: 0.5, animations: { self.x = UIScreen.main.bounds.width }, completion: nil)
        }else { UIView.animate(withDuration: 0.5, animations: { self.x = (UIScreen.main.bounds.width - self.width) - 8 }) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
