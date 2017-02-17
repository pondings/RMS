//
//  QRButtonExtension.swift
//  RMS-2
//
//  Created by Pondz on 2/15/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Foundation

protocol QRButtonDelegate {
    func qrBtnClicked(sender : UIButton)
}

extension QRButtonDelegate where Self : UITabBarController {
    func qrBtnClicked(sender : UIButton) {
        performSegue(withIdentifier: "MainOrder", sender: nil)
    }
}

extension UITabBarController : QRButtonDelegate {}

extension UICollectionViewController {
    
    var lastOffsetY :CGFloat {
        get { return self.lastOffsetY }
        set { self.lastOffsetY = newValue }
    }
    
    func didScroll(last : CGFloat,yPosition : CGFloat,contentHeight : CGFloat,cvHeight : CGFloat){
        var dismiss = true
        if(yPosition < CGFloat(5)){
            dismiss = false
        }else if( (yPosition + 20) > (contentHeight - cvHeight)){
            //Hide QRCode
        }else if (last > yPosition) {
            dismiss = false
        }
        else if (last < yPosition) {
            //Hide QRCode
        }
        NotificationCenter.default.post(name: Notification.Name("hideQRButton"), object: dismiss)
    }
    
}

