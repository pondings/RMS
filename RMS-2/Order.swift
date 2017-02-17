//
//  Order.swift
//  RMS-2
//
//  Created by Pondz on 2/16/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import Foundation

protocol OrderProtocol : MenuProtocol{
    var orderId : Int? { get set }
    var orderNet : Double? { get set }
    var orderQuantity : Double? { get set }
    func calculateNet() -> Double
}

struct Order : OrderProtocol{
    var menuId: Int?
    var orderId: Int?
    var orderNet: Double?
    var orderQuantity: Double?
    var menuPrice: Double?
    var menuDetail: String?
    var menuImageUrl: String?
    var menuTitle: String?
    
    init() {}
    
    init(orderDict : Dictionary<String,AnyObject>) {
        if let menuId = orderDict["menu_id"] as? Int {
            self.menuId = menuId
        }else { self.menuId = 0 }
        
        if let orderId = orderDict["ord_id"] as? Int {
            self.orderId = orderId
        }else { self.orderId = 0 }
        
        if let orderNet = orderDict["ord_net"] as? Double {
            self.orderNet = orderNet
        }else { self.orderNet = 0 }
        
        if let orderQuantity = orderDict["ord_quantity"] as? Int {
            self.orderQuantity = Double.init(orderQuantity)
        }else { self.orderQuantity = 0 }
        
        if let menuPrice = orderDict["menu_price"] as? Double {
            self.menuPrice = menuPrice
        }else { self.menuPrice = 0 }
        
        if let menuDetail = orderDict["menu_desc"] as? String {
            self.menuDetail = menuDetail
        }else { self.menuDetail = "" }
        
        if let menuImageUrl = orderDict["menu_img"] as? String {
            self.menuImageUrl = menuImageUrl
        }else { self.menuImageUrl = "" }
        
        if let menuTitle = orderDict["menu_title"] as? String {
            self.menuTitle = menuTitle
        }else { self.menuTitle = "" }
    }
    
    func calculateNet() -> Double {
        return orderQuantity! * menuPrice!
    }
}
