//
//  Promotion.swift
//  RMS-2
//
//  Created by Pondz on 2/16/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import Foundation

protocol PromotionProtocol {
    var id : Int? {get set}
    var promotionTitle : String? {get set}
    var promotionDetail : String? {get set}
    var promotionImageUrl : String? {get set}
    var promotionPeriod : String? {get set}
}

struct Promotion : PromotionProtocol{
    var id: Int?
    var promotionTitle: String?
    var promotionDetail: String?
    var promotionImageUrl: String?
    var promotionPeriod: String?
    
    init(promotionDict : Dictionary<String,AnyObject>) {
        if let id = promotionDict["id"] as? Int {
            self.id = id
        }
        if let title = promotionDict["pro_title"] as? String {
            self.promotionTitle = title
        }
        if let detail = promotionDict["pro_desc"] as? String {
            self.promotionDetail = detail
        }
        if let imageUrl = promotionDict["pro_img"] as? String {
            self.promotionImageUrl = imageUrl
        }
        if let period = promotionDict["pro_period"] as? String {
            self.promotionPeriod = period
        }
    }
    
}
