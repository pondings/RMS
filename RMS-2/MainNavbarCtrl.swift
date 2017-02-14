//
//  MainNavbarCtrl.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import AFMActionSheet

class MainNavbarCtrl: UINavigationController,CommonNavBarDelegate,SearchNavBarDelegate {
    
    lazy var mainTabBar : MainTabBarCtrl = (self.tabBarController as? MainTabBarCtrl)!
    
    var interactor = Interactor()
    
    lazy var commonNavBar: CommonNavBar = {
        let vw = CommonNavBar.init(frame: CGRect.init(x: 0, y: 0, width: self.navigationBar.frame.width, height: self.navigationBar.frame.height))
        vw.delegate = self
        return vw
    }()
    
    lazy var searchNavBar: SearchNavBar = {
        let vw = SearchNavBar.init(frame: CGRect.init(x: 0, y: 0, width: self.navigationBar.frame.width, height: self.navigationBar.frame.height))
        vw.delegate = self
        return vw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureNavBar(){
        self.delegate = self
        self.navigationBar.addSubview(commonNavBar)
        self.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        self.navigationBar.barTintColor = Color.lightBlue.base
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSelf(_:)), name: Notification.Name("dsNavBar"), object: nil)

    }
    
    func dismissSelf(_ state : Notification){
        let ds = state.object as! Bool
        self.setNavigationBarHidden(ds, animated: true)
    }
    
    func cancleBtnClicked() {
        UIView.transition(from: searchNavBar, to: commonNavBar, duration: 0.5, options: .transitionCrossDissolve, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("hideQR"), object: false)
        searchNavBar.searchBox.text = ""
        self.popViewController(animated: true)
    }
    
    func searchBtnClicked() {
        UIView.transition(from: commonNavBar, to: searchNavBar, duration: 0.5, options: .transitionCrossDissolve, completion: nil)
        searchNavBar.searchBox.becomeFirstResponder()
    }
    
    func moreBtnClicked() {
        NotificationCenter.default.post(name: Notification.Name("activeActionSheet"), object: nil)
    }

    func searchBarDidEnter(text: String) {
        if let vc = self.topViewController as? MainRestaurant {
            vc.searchRestaurant(text: text)
        }else if let vc = self.topViewController as? MainMostView {
            vc.searchMostView(searchText: text)
        }else if let vc = self.topViewController as? MainPromotion {
            vc.searchPromotion(searchText: text )
        }
    }
    
}

extension MainNavbarCtrl : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == .push) { return LeftPresent() }
        else if(operation == .pop) { return LeftEdgeDismiss() }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStart ? interactor : nil
    }
    
}









