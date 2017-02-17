//
//  Constant.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import Foundation
import UIKit

let statusBar = UIApplication.shared.value(forKey: "statusBar") as! UIView
typealias DowloadContentComplete = ([Dictionary<String,AnyObject>]) -> ()
typealias DowloadContentDetailComplete = (Dictionary<String,AnyObject>) -> ()
typealias DowloadImgComplete = ([String]) -> ()

var _urlBase = "http://35.165.196.27:3000/"

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
}
