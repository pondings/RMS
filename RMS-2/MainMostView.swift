//
//  MainMostView.swift
//  RMS-2
//
//  Created by Pondz on 1/21/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Alamofire

class MainMostView: UICollectionViewController,UICollectionViewDelegateFlowLayout,CollectionViewDelegate,DataManagentDelegate {

    private var mostViewList : [Dictionary<String,AnyObject>]! = []
    private var imageCache : [Dictionary<String,UIImage>]! = []
    private let urlPath = "MostView"
    private var lastContentOffset : CGFloat = 0.0
    fileprivate let interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAlamoFire(path: urlPath, downloadComplete: { result in
            self.mostViewList = result
            self.collectionView?.reloadData()
            self.storeImageCache(mostViewList: self.mostViewList)
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("navTitle"), object: "Most View")
    }
    
    private func storeImageCache(mostViewList : [Dictionary<String,AnyObject>]){
        for item in mostViewList {
            let mvDict = Restaurants.init(mvDict: item)
            let urlString = mvDict.img!
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data,response,error) in
                if error != nil {return}
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
                DispatchQueue.main.async {
                    let getImage = UIImage.init(data: data!)!
                    let imageCache = [mvDict.title! : getImage]
                    self.imageCache.append(imageCache)
                }
            }.resume()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mostViewList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RestaurantListCell
        let mvDict = Restaurants.init(mvDict: mostViewList[indexPath.row])
        cell.configureCell(res: mvDict)
        if(imageCache.count == collectionView.numberOfItems(inSection: 0)){
            let targetDict = imageCache.filter({
                let title = Array($0.keys)[0]
                return (title.range(of: cell.title.text!) != nil)
            })
            cell.configreImage(image: Array(targetDict[0].values)[0])
        }else{
            cell.configureImage(url: mvDict.img!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width - 20, height: self.view.frame.height * 0.6)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mvDict = Restaurants.init(mvDict: mostViewList[indexPath.row])
        performSegue(withIdentifier: "Detail", sender: mvDict)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Detail") {
            if let destination = segue.destination as? RestaurantDetail {
                let mostView = sender as! Restaurants
                destination.interactor = interactor
                destination.restaurant = mostView
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
