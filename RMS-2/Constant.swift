//
//  Constant.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import Foundation
import UIKit
import MapKit

typealias DowloadContentComplete = ([Dictionary<String,AnyObject>]) -> ()
typealias DowloadImgComplete = ([String]) -> ()
let statusBar = UIApplication.shared.value(forKey: "statusBar") as! UIView
var _urlBase = "http://35.165.196.27:3000/"
enum state {
    case notFoundContent
    case connectonError
}

func prepareToOpenMap(latitude : String,longtitude : String,title : String){
    let lat : NSString = latitude as NSString
    let long : NSString = longtitude as NSString
    let mapLat : CLLocationDegrees = lat.doubleValue
    let mapLong : CLLocationDegrees = long.doubleValue
    let regionDistance : CLLocationDistance = 1000
    let coordinate = CLLocationCoordinate2DMake(mapLat, mapLong)
    let locationSpan = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
    let options = [ MKLaunchOptionsMapCenterKey : NSValue.init(mkCoordinate: locationSpan.center),
                    MKLaunchOptionsMapSpanKey : NSValue.init(mkCoordinateSpan: locationSpan.span) ]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = "\(title)"
    mapItem.openInMaps(launchOptions: options)
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
}
