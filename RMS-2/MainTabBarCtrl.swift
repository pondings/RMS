//
//  MainTabBarCtrl.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material

class MainTabBarCtrl: UITabBarController,UITabBarControllerDelegate {
    
    var isSearch : Bool = false
    var previousViewCntroller : UIViewController? = nil
    
    lazy var bottomBarFrame : CGRect = self.tabBar.frame
    lazy var viewFrame : CGRect = self.view.frame
    
    lazy var lightBlueView: UIView = {
        let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.viewFrame.width, height: 20))
        vw.backgroundColor = Color.lightBlue.base
        return vw
    }()
    
    lazy var qrBtn: QRButton = {
        let height : CGFloat = 60
        let width : CGFloat = 60
        let xPosition : CGFloat = self.viewFrame.width - 68
        let yPosition : CGFloat = (self.viewFrame.height - 68) - self.bottomBarFrame.height
        let btn = QRButton.init(frame: CGRect.init(x: xPosition, y: yPosition, width: height, height: width))
        btn.layer.cornerRadius = 30
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.addSubview(lightBlueView)
        tabBar.barTintColor = Color.lightBlue.base
        view.backgroundColor = .white
        self.view.addSubview(qrBtn)
        NotificationCenter.default.addObserver(self, selector: #selector(hideQRBtn(notification:)), name: Notification.Name("hideQR"), object: nil)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.selectedImage = item.image?.tint(with: Color.white)
        let NAV = self.selectedViewController as? MainNavbarCtrl
        NAV?.cancleBtnClicked()
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
    
}
