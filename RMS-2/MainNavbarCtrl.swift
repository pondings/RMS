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
    
    var interactor = Interactor()
    var selfInteractor : Interactor? = nil
    
    var isBackButtonHidden : Bool {
        get { return self.commonNavBar.backBtn.isHidden }
        set { self.commonNavBar.backBtn.isHidden = newValue }
    }
    
    var setNavbarTitle : String {
        get { return commonNavBar.titleLB.text! }
        set { self.commonNavBar.titleLB.text = newValue }
    }
    
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
    
    private lazy var leftEdgeDismissal: UIScreenEdgePanGestureRecognizer = {
        let lf = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(leftEdgeDismissal(_:)))
        lf.edges = .left
        return lf
    }()
    
    lazy var mainTabBar : MainTabBarCtrl = (self.tabBarController as? MainTabBarCtrl)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    private func configureNavBar(){
        delegate = self
        navigationBar.addSubview(commonNavBar)
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = Color.lightBlue.base
        view.backgroundColor = .white
        view.addGestureRecognizer(leftEdgeDismissal)
        hidesBarsOnSwipe = true
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
    
    internal func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func dismissSelf(_ state : Notification){
        let ds = state.object as! Bool
        self.setNavigationBarHidden(ds, animated: true)
    }
    
    
    internal func leftEdgeDismissal(_ sender : UIScreenEdgePanGestureRecognizer){
        let percentThreshold:CGFloat = 0.7
        let translation = sender.translation(in: view)
        let horizontalMovement = translation.x / view.bounds.width
        let leftMovement = fmaxf(Float(horizontalMovement), 0.0)
        let leftMovementPercent = fminf(leftMovement, 1.0)
        let progress = CGFloat(leftMovementPercent)
        
        guard  let interactor = selfInteractor else {return}
        switch sender.state {
        case .began:
            interactor.hasStart = true
            self.dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStart = false
            interactor.cancel()
        case .ended:
            interactor.hasStart = false
            if(interactor.shouldFinish) { interactor.finish()}
            else { interactor.cancel() }
        default:
            break
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









