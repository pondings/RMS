//
//  Restaurant.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import Foundation

protocol Restaurant {
    var title : String? {get set}
    var desc : String? {get set}
    var img : String? {get set}
    var subTitle : String? {get set}
}

struct Restaurants : Restaurant {
    var subTitle: String?
    var img: String?
    var desc: String?
    var title: String?

    init(restDict : Dictionary<String,AnyObject>) {
        if let title = restDict["res_name"] as? String {
            self.title = title
        }
        if let desc = restDict["res_desc"] as? String {
            self.desc = desc
        }
        if let img = restDict["res_img"] as? String {
            self.img = img
        }
        if let location = restDict["res_location"] as? String {
            self.subTitle = location
        }
    }
    
    init(proDict : Dictionary<String,AnyObject>) {
        if let title = proDict["pro_title"] as? String {
            self.title = title
        }
        if let desc = proDict["pro_desc"] as? String {
            self.desc = desc
        }
        if let img = proDict["pro_img"] as? String {
            self.img = img
        }
        if let period = proDict["pro_period"] as? String {
            self.subTitle = period
        }
    }
}

extension Restaurant {
    
}
