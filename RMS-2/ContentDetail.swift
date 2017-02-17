//
//  ContentDetail.swift
//  RMS-2
//
//  Created by Pondz on 2/16/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import Foundation
import MapKit

protocol ContentDetailProtocol : LocationProtocol,LocationCoordinate {
    var contentTitle : String? {get set}
    var contentDetail : String? {get set}
    var contentImageUrl : String? {get set}
}

protocol LocationProtocol {
    var locationTitle : String? {get set}
}

protocol LocationCoordinate {
    var locationLatitude : Double? {get set}
    var locationLongtitude : Double? {get set}
    func openMap() -> Bool
}

protocol ContentDetailSupportProtocol {}

struct ContentDetail : ContentDetailProtocol,ContentDetailSupportProtocol {
    
    var contentTitle: String?
    var contentDetail: String?
    var contentImageUrl: String?
    var locationTitle: String?
    var locationLatitude: Double?
    var locationLongtitude: Double?
    
    enum contentStyle {
        case restaurant,mostView,promotion
    }
    
    private var stringArray : [String]! = []
    
    init(Dictinary obj : Dictionary<String,AnyObject>,contentStyle : contentStyle) {
        switch contentStyle {
        case .restaurant:
            stringArray = ["res_name","res_location","res_desc","res_img","location_lat","location_long"]
        case .mostView:
            stringArray = ["mv_title","mv_location","mv_desc","mv_img","location_lat","location_long"]
        case .promotion:
            stringArray = ["pro_title","pro_location","pro_desc","pro_img","location_lat","location_long"]
        }
        
        if let contentTitle = obj[stringArray[0]] as? String {
            self.contentTitle = contentTitle
        }else { self.contentTitle = "" }
        
        if let locationTitle = obj[stringArray[1]] as? String {
            self.locationTitle = locationTitle
        }else { self.locationTitle = "" }
        
        if let contentDetail = obj[stringArray[2]] as? String {
            self.contentDetail = contentDetail
        }else { self.contentDetail = "" }
        
        if let contentImageUrl = obj[stringArray[3]] as? String {
            self.contentImageUrl = contentImageUrl
        }else { self.contentImageUrl = "" }
        
        if let locationLatitude = obj[stringArray[4]] as? Double {
            self.locationLatitude = locationLatitude
        }else { self.locationLatitude = nil }
        
        if let locationLongtitude = obj[stringArray[5]] as? Double {
            self.locationLongtitude = locationLongtitude
        }else { self.locationLongtitude = nil }
    }
    
    func openMap() -> Bool {
        if(locationLatitude == nil || locationLongtitude == nil) { return false }
        let regionDistance : CLLocationDistance = 1000
        let coordinate = CLLocationCoordinate2DMake(locationLatitude!, locationLongtitude!)
        let locationSpan = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
        let options = [ MKLaunchOptionsMapCenterKey : NSValue.init(mkCoordinate: locationSpan.center),
                        MKLaunchOptionsMapSpanKey : NSValue.init(mkCoordinateSpan: locationSpan.span) ]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(locationTitle!)"
        mapItem.openInMaps(launchOptions: options)
        return true
    }
    
}
