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
    
    init(mvDict : Dictionary<String,AnyObject>) {
        if let title = mvDict["mv_title"] as? String {
            self.title = title
        }
        if let desc = mvDict["mv_desc"] as? String {
            self.desc = desc
        }
        if let img = mvDict["mv_img"] as? String {
            self.img = img
        }
        if let location = mvDict["mv_location"] as? String {
            self.subTitle = location
        }
    }
}

protocol Menu {
    var title : String? {get set}
    var img : String? {get set}
    var desc : String? {get set}
    var price : Int? {get set}
    var totalPrice : String? {get set}
    var quantity : String? {get set}
}

struct Menus : Menu{
    var price: Int?
    var desc: String?
    var img: String?
    var title: String?
    var totalPrice: String?
    var quantity : String?
    
    init(ordDict : Dictionary<String,AnyObject>) {
        if let title = ordDict["ord_name"] as? String {
            self.title = title
        }
        if let img = ordDict["ord_img"] as? String {
            self.img = img
        }
        if let price = ordDict["ord_price"] as? Int  {
            self.price = price
        }
        if let quantity = ordDict["ord_total"] as? Int {
            self.quantity = "\(quantity)"
        }
    }
    
    init(menuDict : Dictionary<String,AnyObject>) {
        if let title = menuDict["menu_name"] as? String {
            self.title = title
        }
        if let desc = menuDict["menu_desc"] as? String {
            self.desc = desc
        }
        if let img = menuDict["menu_img"] as? String {
            self.img = img
        }
        if let price = menuDict["menu_price"] as? Int {
            self.price = price
        }
    }
}
