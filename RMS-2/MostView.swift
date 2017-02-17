//
//  MostView.swift
//  RMS-2
//
//  Created by Pondz on 2/16/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import Foundation

protocol MostViewProtocol {
    var id : Int? {get set}
    var mostViewTitle : String? {get set}
    var mostViewDetail : String? {get set}
    var mostViewImageUrl : String? {get set}
}

struct MostView : MostViewProtocol,LocationProtocol{
    var id: Int?
    var mostViewTitle: String?
    var mostViewDetail: String?
    var mostViewImageUrl: String?
    var locationTitle: String?
    
    init(mostViewDict : Dictionary<String,AnyObject>) {
        
        if let id = mostViewDict["id"] as? Int {
            self.id = id
        }else { self.id = 0 }
        
        if let title = mostViewDict["mv_title"] as? String {
            self.mostViewTitle = title
        }else { self.mostViewTitle = "" }
        
        if let detail = mostViewDict["mv_desc"] as? String {
            self.mostViewDetail = detail
        }else { self.mostViewDetail = "" }
        
        if let imageUrl = mostViewDict["mv_img"] as? String {
            self.mostViewImageUrl = imageUrl
        }else { mostViewImageUrl = "" }
        
        if let locationTitle = mostViewDict["mv_location"] as? String {
            self.locationTitle = locationTitle
        }else { self.locationTitle = "" }
    }
}
