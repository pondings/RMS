//
//  MainMostView.swift
//  RMS-2
//
//  Created by Pondz on 1/21/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Alamofire

class MainMostView: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    private var mostViewList : [Dictionary<String,AnyObject>]! = []
    private var mostViewListFiltered : [Dictionary<String,AnyObject>]! = []
    private var isSearchMode : Bool = false
    private var imageCache : [Dictionary<String,UIImage>]! = []
    private let urlPath = "MostView"
    private var lastContentOffset : CGFloat = 0.0
    fileprivate let interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAlamoFire(path: urlPath, downloadComplete: { result in
            self.mostViewList = result
            self.reloadVC()
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("navTitle"), object: "Most View")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchMode ? mostViewListFiltered.count : mostViewList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RestaurantListCell
        let mostView = isSearchMode ? mostViewListFiltered[indexPath.row] : mostViewList[indexPath.row]
        let mvDict = MostView.init(mostViewDict: mostView)
        cell.configureCell(mostView: mvDict)
        cell.configureImage(url: mvDict.mostViewImageUrl!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width - 20, height: self.view.frame.height * 0.6)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mvDict = Restaurant.init(restaurantDict: mostViewList[indexPath.row])
        configureAlamofire(path: "MostView/\(mvDict.id!)", downloadComplete: { result in
            self.performSegue(withIdentifier: "Detail", sender: result)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Detail") {
            if let destination = segue.destination as? RestaurantDetail {
                destination.contentDetail = ContentDetail.init(Dictinary: sender as! Dictionary<String,AnyObject> , contentStyle: .mostView)
                destination.interactor = interactor
                destination.transitioningDelegate = self
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(last: self.lastContentOffset,yPosition: (collectionView?.contentOffset.y)!,contentHeight: (collectionView?.contentSize.height)!,cvHeight: (collectionView?.frame.height)!)

    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func searchMostView(searchText text: String){
        mostViewListFiltered = mostViewList.filter({
            if(text != "") {
                let title = $0["mv_title"] as! String
                self.isSearchMode = true
                return (title.range(of: text) != nil)
            }else {
                self.isSearchMode = false
                return false
            }
        })
        self.reloadVC()
    }
}

extension MainMostView : UIViewControllerTransitioningDelegate {
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStart ? interactor : nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PullDownDismiss()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomPresent()
    }
}
