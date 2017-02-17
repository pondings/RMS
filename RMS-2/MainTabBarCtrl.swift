//
//  MainTabBarCtrl.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import AFMActionSheet
import Kingfisher

class MainTabBarCtrl: UITabBarController,UITabBarControllerDelegate,QRReaderDelegate {
    
    @IBOutlet weak var titleView : UIView!
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var nameLb : UILabel!
    
    var previousViewCntroller : UIViewController? = nil
    var interactor = Interactor()
    
    lazy var bottomBarFrame : CGRect = self.tabBar.frame
    lazy var viewFrame : CGRect = self.view.frame
    
    lazy var qrBtn: QRButton = {
        let height : CGFloat = 60
        let width : CGFloat = 60
        let xPosition : CGFloat = self.viewFrame.width - 68
        let yPosition : CGFloat = (self.viewFrame.height - 68) - self.bottomBarFrame.height
        let btn = QRButton.init(frame: CGRect.init(x: xPosition, y: yPosition, width: height, height: width))
        btn.layer.cornerRadius = 30
        btn.delegate = self
        return btn
    }()
    
    lazy var lightBlueView: UIView = {
        let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.viewFrame.width, height: 20))
        vw.backgroundColor = Color.lightBlue.base
        return vw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.barTintColor = Color.lightBlue.base
        view.backgroundColor = .white
        view.addSubview(qrBtn)
        view.addSubview(lightBlueView)
        NotificationCenter.default.addObserver(self, selector: #selector(moreBtnClicked), name: Notification.Name("activeActionSheet"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let nav = self.selectedViewController as? MainNavbarCtrl {
            nav.isBackButtonHidden = true
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.selectedImage = item.image?.tint(with: Color.white)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if(viewController == previousViewCntroller){
            let nav = viewController as? MainNavbarCtrl
            let vc = nav?.topViewController as? UICollectionViewController
            if((vc?.collectionView?.numberOfItems(inSection: 0))! < 1) {return}
            vc?.collectionView?.setContentOffset(CGPoint.zero, animated: true)
        }
        previousViewCntroller = viewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QRReader") {
            if let destination = segue.destination as? QRReader{
                destination.interactor = interactor
                destination.transitioningDelegate = self
                destination.delegate = self
            }
        }else if(segue.identifier == "MainOrder") {
            if let destination = segue.destination as? MainNavbarCtrl{
                destination.transitioningDelegate = self
                destination.selfInteractor = interactor
            }
        }
    }
    
    func moreBtnClicked() {
        
    }
    
}

extension MainTabBarCtrl : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented is MainNavbarCtrl {
            return PushToLeft()
        }
        return QRReaderPresent()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is MainNavbarCtrl {
            return PullToRight()
        }
        return QRReaderDismiss()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStart ? interactor : nil
    }
}
