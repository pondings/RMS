//
//  MainTabBarCtrl.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import FBSDKLoginKit

class MainTabBarCtrl: UITabBarController,UITabBarControllerDelegate,QRButtonDelegate,QRReaderDelegate {
    
    var isSearch : Bool = false
    var previousViewCntroller : UIViewController? = nil
    var interactor = Interactor()
    
    lazy var bottomBarFrame : CGRect = self.tabBar.frame
    lazy var viewFrame : CGRect = self.view.frame
    
    lazy var lightBlueView: UIView = {
        let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.viewFrame.width, height: 20))
        vw.backgroundColor = Color.lightBlue.base
        return vw
    }()
    
    lazy var mainNavBar : MainNavbarCtrl = self.navigationController as! MainNavbarCtrl
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        view.addSubview(lightBlueView)
        tabBar.barTintColor = Color.lightBlue.base
        view.backgroundColor = .white
        view.addSubview(qrBtn)
        NotificationCenter.default.addObserver(self, selector: #selector(hideQRBtn(notification:)), name: Notification.Name("hideQR"), object: nil)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.selectedImage = item.image?.tint(with: Color.white)
//        let NAV = self.selectedViewController as? MainNavbarCtrl
//        let VC = NAV?.childViewControllers[0] as? UICollectionViewController
    }
    
    func isFoundQRCode(qrCode: String) {
        performSegue(withIdentifier: "MainOrder", sender: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if(viewController == previousViewCntroller){
            let NAV = viewController as? MainNavbarCtrl
            let VC = NAV?.topViewController as? UICollectionViewController
            VC?.collectionView?.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
        }
        previousViewCntroller = viewController
    }
    
    func hideQRBtn(notification : Notification){
        let state = notification.object as! Bool
        qrBtn.hideSelf(isHidden: state)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QRReader") {
            if let destination = segue.destination as? QRReader{
                destination.interactor = interactor
                destination.transitioningDelegate = self
                destination.delegate = self
            }
        }else if(segue.identifier == "MainOrder") {
            if let destination = segue.destination as? OrderNavBarCtrl{
                destination.transitioningDelegate = self
                destination.interactor = interactor
            }
        }
    }
    
}

extension MainTabBarCtrl : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented is OrderNavBarCtrl {
            return PushToLeft()
        }
        return QRReaderPresent()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is OrderNavBarCtrl {
            return PullToRight()
        }
        return QRReaderDismiss()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStart ? interactor : nil
    }
    
}
