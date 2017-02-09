//
//  UIViewControllerExtens.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin

protocol CollectionViewDelegate {
    func didScroll(last : CGFloat,yPosition : CGFloat,contentHeight : CGFloat,cvHeight : CGFloat)
}

protocol TableViewDelegate {
    func didScroll(last : CGFloat,yPosition : CGFloat,contentHeight : CGFloat,cvHeight : CGFloat)
}

extension TableViewDelegate where Self : UITableViewDelegate {
    func didScroll(last : CGFloat,yPosition : CGFloat,contentHeight : CGFloat,cvHeight : CGFloat){
        var dismiss = true
        if(yPosition < CGFloat(5)){
            dismiss = false
        }else if( (yPosition + 20) > (contentHeight - cvHeight)){
            //Hide Navbar
        }else if (last > yPosition) {
            dismiss = false
        }
        else if (last < yPosition) {
            //Hide Navbar
        }
        NotificationCenter.default.post(name: Notification.Name("dsOrdNavBar"), object: dismiss)
    }
}

extension CollectionViewDelegate where Self : UIViewController {
    func didScroll(last : CGFloat,yPosition : CGFloat,contentHeight : CGFloat,cvHeight : CGFloat){
        var dismiss = true
        if(yPosition < CGFloat(5)){
            dismiss = false
        }else if( (yPosition + 20) > (contentHeight - cvHeight)){
            //Hide Navbar
        }else if (last > yPosition) {
            dismiss = false
        }
        else if (last < yPosition) {
            //Hide Navbar
        }
        NotificationCenter.default.post(name: Notification.Name("dsNavBar"), object: dismiss)
        NotificationCenter.default.post(name: Notification.Name("hideQR"), object: dismiss)
    }
}

extension CollectionViewDelegate where Self : UICollectionViewController {
    
    func didScroll(last : CGFloat,yPosition : CGFloat,contentHeight : CGFloat,cvHeight : CGFloat){
        var dismiss = true
        if(yPosition < CGFloat(5)){
            dismiss = false
        }else if( (yPosition + 20) > (contentHeight - cvHeight)){
            //Hide Navbar
        }else if (last > yPosition) {
            dismiss = false
        }
        else if (last < yPosition) {
            //Hide Navbar
        }
        NotificationCenter.default.post(name: Notification.Name("dsNavBar"), object: dismiss)
        NotificationCenter.default.post(name: Notification.Name("hideQR"), object: dismiss)
    }
}

extension UIViewController {

    func AccountManagement() {
        self.performSegue(withIdentifier: "AuthenicationVC", sender: nil)
    }
    
}


