//
//  ViewController.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class MainRestaurant: UICollectionViewController,UICollectionViewDelegateFlowLayout,CollectionViewDelegate {
    
    private let urlPath : String = "Restaurant"
    private var isSearchMode : Bool = false
    private var restaurantList : [Dictionary<String,AnyObject>]! = []
    private var restaurantFiltered : [Dictionary<String,AnyObject>]! = []
    private var imageCache : [Dictionary<String,UIImage>]! = []
    fileprivate let interactor = Interactor()
    
    private var lastContentOffset : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAlamoFire(path: urlPath, downloadComplete: { result in
            self.restaurantList = result
            self.reloadVC()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("navTitle"), object: "Restaurant")
        navigationController?.tabBarItem.selectedImage = navigationController?.tabBarItem.image?.tint(with: .white)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RestaurantListCell
        let restaurant = isSearchMode ? restaurantFiltered[indexPath.row] : restaurantList[indexPath.row]
        let resDict = Restaurants.init(restDict: restaurant)
        cell.configureCell(res: resDict)
        cell.configureImage(url: resDict.img!)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchMode ? restaurantFiltered.count : restaurantList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width - 20, height: collectionView.frame.height * 0.6)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restaurant = Restaurants.init(restDict: restaurantList[indexPath.row])
        performSegue(withIdentifier: "Detail", sender: restaurant)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            if let detail = segue.destination as? RestaurantDetail{
                let restaurant = sender as! Restaurants
                detail.restaurant = restaurant
                detail.transitioningDelegate = self
                detail.interactor = interactor
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(last: self.lastContentOffset,yPosition: (collectionView?.contentOffset.y)!,contentHeight: (collectionView?.contentSize.height)!,cvHeight: (collectionView?.frame.height)!)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func searchRestaurant(text : String){
        restaurantFiltered = restaurantList.filter({
            if(text != "") {
                let resName = $0["res_name"] as! String
                self.isSearchMode = true
                return (resName.range(of: text) != nil)
            }else{
                self.isSearchMode = false
                return false
            }
        })
        self.reloadVC()
    }
    
}

extension MainRestaurant : UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomPresent()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PullDownDismiss()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStart ? interactor : nil
    }
    
}
