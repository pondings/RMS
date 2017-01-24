//
//  MainPromotion.swift
//  RMS-2
//
//  Created by Pondz on 1/21/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit

class MainPromotion: MainRestaurant {
    
    override var urlPath: String {
        get {
            return "Promotion"
        }set {
            self.urlPath = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("navTitle"), object: "Promotion")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewContentCell
        cell.configureCell(pro: Restaurants.init(proDict: restaurantList![indexPath.row]))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restaurant = Restaurants.init(proDict: restaurantList[indexPath.row])
        performSegue(withIdentifier: "Detail", sender: restaurant)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            if let detail = segue.destination as? RestaurantDetail {
                let restaurant = sender as? Restaurants
                detail.transitioningDelegate = self
                detail.interactor = interactor
                detail.restaurant = restaurant
            }
        }
    }
    
}
