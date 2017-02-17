//
//  Restaurant.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import Foundation
import MapKit



protocol RestaurantProtocol {
    var id : Int? {get set}
    var restaurantTitle : String? {get set}
    var restaurantDetail : String? {get set}
    var restaurantImageUrl : String? {get set}
}

protocol RestaurantContactProtocol {
    var restaurantPhone : String? {get set}
}

struct Restaurant : RestaurantProtocol,LocationProtocol {
    var id: Int?
    var restaurantImageUrl: String?
    var restaurantDetail: String?
    var restaurantTitle: String?
    var locationTitle: String?
    
    init(restaurantDict : Dictionary<String,AnyObject>) {
        if let id = restaurantDict["id"] as? Int {
            self.id = id
        }else { self.id = 0 }
        
        if let title = restaurantDict["res_name"] as? String {
            self.restaurantTitle = title
        }
        if let detail = restaurantDict["res_desc"] as? String {
            self.restaurantDetail = detail
        }
        if let imageUrl = restaurantDict["res_img"] as? String {
            self.restaurantImageUrl = imageUrl
        }
        if let locationTitle = restaurantDict["res_location"] as? String {
            self.locationTitle = locationTitle
        }
    }
//    func openMap() {
//        let regionDistance : CLLocationDistance = 1000
//        let coordinate = CLLocationCoordinate2DMake(locationLatitude!, locationLongtitude!)
//        let locationSpan = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
//        let options = [ MKLaunchOptionsMapCenterKey : NSValue.init(mkCoordinate: locationSpan.center),
//                        MKLaunchOptionsMapSpanKey : NSValue.init(mkCoordinateSpan: locationSpan.span) ]
//        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = "\(locationTitle!)"
//        mapItem.openInMaps(launchOptions: options)
//    }
}
