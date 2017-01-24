//
//  MainTabBarCtrl.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material

class MainTabBarCtrl: UITabBarController,CommonNavBarDelegate,SearchNavBarDelegate,UITabBarControllerDelegate {
    
    var isSearch : Bool = false
    var previousViewCntroller : UIViewController? = nil
    
    lazy var navBar : UINavigationBar = (self.navigationController?.navigationBar)!
    lazy var bottomBarFrame : CGRect = self.tabBar.frame
    lazy var viewFrame : CGRect = self.view.frame
    
    lazy var commonNavBar: CommonNavBar = {
        let vw = CommonNavBar.init(frame: CGRect.init(x: 0, y: 0, width: self.navBar.frame.width, height: self.navBar.frame.height))
        vw.delegate = self
        return vw
    }()
    
    lazy var searchNavBar: SearchNavBar = {
        let vw = SearchNavBar.init(frame: CGRect.init(x: 0, y: 0, width: self.navBar.frame.width, height: self.navBar.frame.height))
        vw.delegate = self
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
    
    lazy var lightBlueView: UIView = {
        let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.viewFrame.width, height: 20))
        vw.backgroundColor = Color.lightBlue.base
        return vw
    }()
    
    lazy var searchDetail: SearchDetail = {
        let size = CGSize.init(width: self.view.frame.width, height: (self.view.frame.height - (self.tabBar.height + self.navBar.height)) - 8)
        let point = CGPoint.init(x: -self.view.frame.width, y: self.navBar.height + 8)
        let vw = SearchDetail.init(frame: CGRect.init(origin: point, size: size))
        return vw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.addSubview(lightBlueView)
        tabBar.barTintColor = Color.lightBlue.base
        navBar.addSubview(commonNavBar)
        view.backgroundColor = .white
        view.addSubview(qrBtn)
        NotificationCenter.default.addObserver(self, selector: #selector(hideQRBtn(notification:)), name: Notification.Name("hideQR"), object: nil)
    }
    
    func searchTextDidChange(text: String) {
        view.addSubview(searchDetail)
        searchDetail.searchForResraurant(text : "Hellow world")
        previousViewCntroller = nil
        UIView.animate(withDuration: 0.5, animations: {
            self.searchDetail.frame = CGRect.init(origin: CGPoint.init(x: 0, y: self.navBar.frame.height + 8), size: self.searchDetail.frame.size)
        })
    }
    
    func hideQRBtn(notification : Notification){
        let state = notification.object as! Bool
        if(state){
            UIView.animate(withDuration: 1, animations: {
                 self.qrBtn.transform = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
            }, completion: nil)
        }else{
            self.qrBtn.isHidden = false
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 3, options: .allowAnimatedContent, animations: {
                self.qrBtn.transform = .identity
            }, completion: nil)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.selectedImage = item.image?.tint(with: Color.white)
        UIView.transition(from: searchNavBar, to: commonNavBar, duration: 0.5, options: .transitionCrossDissolve, completion: nil)
        UIView.animate(withDuration: 0.5, animations: {
            self.searchDetail.frame = CGRect.init(origin: CGPoint.init(x: -self.view.frame.width, y: self.navBar.frame.height + 8), size: self.searchDetail.frame.size)
        })
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if(viewController == previousViewCntroller){
            let VC = viewController as? UICollectionViewController
            VC?.collectionView?.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
        }
        previousViewCntroller = viewController
    }
    
    
    func searchBtnClicked() {
        UIView.transition(from: commonNavBar, to: searchNavBar, duration: 0.5, options: .transitionCrossDissolve, completion: nil)
    }
    
    func moreBtnClicked() {
        
    }
    
    func cancleBtnClicked() {
        UIView.transition(from: searchNavBar, to: commonNavBar, duration: 0.5, options: .transitionCrossDissolve, completion: nil)
        UIView.animate(withDuration: 0.5, animations: {
            self.searchDetail.frame = CGRect.init(origin: CGPoint.init(x: -self.view.frame.width, y: self.navBar.frame.height + 8), size: self.searchDetail.frame.size)
        })
        searchNavBar.searchBox.text = ""
    }
    
}
