//
//  MainTabBarCtrl.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material

class MainTabBarCtrl: UITabBarController,CommonNavBarDelegate,SearchNavBarDelegate {
    
    private var isSearchMode : Bool = false
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(lightBlueView)
        self.tabBar.barTintColor = Color.lightBlue.base
        navBar.addSubview(commonNavBar)
        self.view.backgroundColor = .white
        self.view.addSubview(qrBtn)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.selectedImage = item.image?.tint(with: Color.white)
    }
    
    func searchBtnClicked() {
        UIView.transition(from: commonNavBar, to: searchNavBar, duration: 0.5, options: .transitionCrossDissolve, completion: nil)
    }
    
    func moreBtnClicked() {
        
    }
    
    func cancleBtnClicked() {
        UIView.transition(from: searchNavBar, to: commonNavBar, duration: 0.5, options: .transitionCrossDissolve, completion: nil)
    }
    
}
