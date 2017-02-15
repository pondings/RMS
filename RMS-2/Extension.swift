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

extension UIViewController {

    func AccountManagement() {
        self.performSegue(withIdentifier: "AuthenicationVC", sender: nil)
    }
    
}


