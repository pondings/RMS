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
            self.storeImageCache(promotionList: self.promotionList)
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("navTitle"), object: "Promotion")
    }
    
    private func storeImageCache(promotionList : [Dictionary<String,AnyObject>]){
        for item in promotionList {
            let proDict = Restaurants.init(proDict: item)
            let urlString = proDict.img!
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data,response,error) in
                if error != nil {return}
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
                DispatchQueue.main.async {
                    let getImage = UIImage.init(data: data!)!
                    let imageCache = [proDict.title! : getImage]
                    self.imageCache.append(imageCache)
                }
            }.resume()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promotionList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RestaurantListCell
        let proDict = Restaurants.init(proDict: promotionList[indexPath.row])
        cell.configureCell(pro: proDict)
        if(imageCache.count == collectionView.numberOfItems(inSection: 0)) {
            let targetDict = imageCache.filter({
                let title = Array($0.keys)[0]
                return (title.range(of: cell.title.text!) != nil)
            })
            cell.configreImage(image: Array(targetDict[0].values)[0])
        }else {
            cell.configureImage(url: proDict.img!)
        }
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


