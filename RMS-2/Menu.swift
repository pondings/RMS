//
//  Menu.swift
//  RMS-2
//
//  Created by Pondz on 2/16/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import Foundation

protocol MenuProtocol {
    var menuId : Int? {get set}
    var menuTitle : String? { get set }
    var menuImageUrl : String? { get set }
    var menuDetail : String? { get set }
    var menuPrice : Double? { get set }
}

protocol MenuSuggestion {
    var isSuggestion : Bool? {get set}
}

struct Menu : MenuProtocol,MenuSuggestion{
    var menuId: Int?
    var menuTitle: String?
    var menuImageUrl: String?
    var menuDetail: String?
    var menuPrice: Double?
    var isSuggestion: Bool?
    
    init(menuDict : Dictionary<String,AnyObject>) {
        if let id = menuDict["id"] as? Int {
            self.menuId = id
        }
        if let title = menuDict["menu_name"] as? String {
            self.menuTitle = title
        }
        if let imageUrl = menuDict["menu_img"] as? String {
            self.menuImageUrl = imageUrl
        }
        if let detail = menuDict["menu_desc"] as? String {
            self.menuDetail = detail
        }
        if let price = menuDict["menu_price"] as? Double {
            self.menuPrice = price
        }
        if let suggestion  = menuDict["suggestion"] as? Bool {
            self.isSuggestion = suggestion
        }
    }
}

