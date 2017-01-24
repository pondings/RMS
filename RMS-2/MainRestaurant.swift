//
//  ViewController.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Alamofire

class MainRestaurant: UICollectionViewController,UICollectionViewDelegateFlowLayout,CollectionViewDelegate {
    
    var urlPath : String = "Restaurant"
    var restaurantList : [Dictionary<String,AnyObject>]! = []
    var restaurantFiltered : [Dictionary<String,AnyObject>]! = []
    let interactor = Interactor()
    enum state {
        case notFoundContent
    }
    
    private var lastContentOffset : CGFloat = 0.0
    
    lazy var emptyDataView: EmptyData = {
        let vw = EmptyData.init(frame: CGRect.init(origin: self.view.frame.origin, size: self.view.frame.size))
        return vw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configAlamofire {
            self.collectionView?.reloadData()
            self.emptyDataView.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("navTitle"), object: "Restaurant")
        tabBarItem.selectedImage = tabBarItem.image?.tint(with: .white)
    }
    
    func showEmptyData(state : state){
        switch state {
        case .notFoundContent:
            emptyDataView.emptyState(state: .notFoundContent)
            view.addSubview(emptyDataView)
        default:
            break
        }
    }
    
    func configAlamofire(downloadComplete : @escaping DowloadComplete){
        Alamofire.request("\(_urlBase)\(urlPath)").responseJSON { response in
            if(response.result.isFailure) { return }
            let data = response.result.value as! [String:AnyObject]
            self.restaurantList.removeAll()
            self.restaurantFiltered.removeAll()
            for item in data.values {
                self.restaurantList.append(item as! Dictionary<String,AnyObject>)
            }
            downloadComplete()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewContentCell
        cell.configureCell(res: Restaurants.init(restDict: restaurantList[indexPath.row]))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantList.count
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
