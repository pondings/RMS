//
//  MainPromotion.swift
//  RMS-2
//
//  Created by Pondz on 1/21/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Alamofire
import Material

class MainPromotion: UICollectionViewController,UICollectionViewDelegateFlowLayout,CollectionViewDelegate {
    
    private let urlPath = "Promotion"
    private var promotionList : [Dictionary<String,AnyObject>]! = []
    private var promotionListFiltered : [Dictionary<String,AnyObject>]! = []
    private var isSearchMode : Bool = false
    private var imageCache : [Dictionary<String,UIImage>]! = []
    private var lastContentOffset : CGFloat = 0.0
    fileprivate let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureAlamoFire(path: urlPath, downloadComplete: { result in
            self.promotionList = result
            self.reloadVC()
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("navTitle"), object: "Promotion")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchMode ? promotionListFiltered.count : promotionList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RestaurantListCell
        let promotion = isSearchMode ? promotionListFiltered[indexPath.row] : promotionList[indexPath.row]
        let proDict = Restaurants.init(proDict: promotion)
        cell.configureCell(pro: proDict)
        cell.configureImage(url: proDict.img!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width - 20, height: self.view.frame.height * 0.6)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let promotion = Restaurants.init(proDict: promotionList[indexPath.row])
        performSegue(withIdentifier: "Detail", sender: promotion)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            if let detail = segue.destination as? RestaurantDetail {
                let promotion = sender as? Restaurants
                detail.transitioningDelegate = self
                detail.interactor = interactor
                detail.restaurant = promotion
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(last: self.lastContentOffset,yPosition: (collectionView?.contentOffset.y)!,contentHeight: (collectionView?.contentSize.height)!,cvHeight: (collectionView?.frame.height)!)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func searchPromotion(searchText text : String){
        
        promotionListFiltered = promotionList.filter({
            if(text != ""){
                let title = $0["pro_title"] as! String
                self.isSearchMode = true
                return (title.range(of: text) != nil)
            }else{
                self.isSearchMode = false
                return false
            }
        })
        self.reloadVC()
    }
}

extension MainPromotion : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomPresent()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStart ? interactor : nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PullDownDismiss()
    }
    
}


