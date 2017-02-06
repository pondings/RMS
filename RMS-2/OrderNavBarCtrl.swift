//
//  OrderNavBarCtrl.swift
//  RMS-2
//
//  Created by Pondz on 1/27/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material

class OrderNavBarCtrl: UINavigationController,CommonNavBarDelegate {

    var interactor : Interactor? = nil
    
    lazy var commonNavBar: CommonNavBar = {
        let vw = CommonNavBar.init(frame: CGRect.init(x: 0, y: 0, width: self.navigationBar.frame.width, height: self.navigationBar.frame.height))
        vw.backBtn.isHidden = false
        vw.delegate = self
        return vw
    }()
    
    lazy var searchNavBar: SearchNavBar = {
        let vw = SearchNavBar.init(frame: CGRect.init(x: 0, y: 0, width: self.navigationBar.frame.width, height: self.navigationBar.frame.height))
        return vw
    }()
    
    lazy var leftEdgeDismissal: UIScreenEdgePanGestureRecognizer = {
        let lf = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(leftEdgeDismissal(_:)))
        lf.edges = .left
        return lf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(leftEdgeDismissal)
        navigationBar.addSubview(commonNavBar)
        navigationBar.isTranslucent = false
        view.backgroundColor = .white
        navigationBar.barTintColor = Color.lightBlue.base
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSelf(_:)), name: Notification.Name("dsOrdNavBar"), object: nil)
    }
    
    func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func moreBtnClicked() {}
    
    func searchBtnClicked() {}
    
    func dismissSelf(_ state : Notification){
        let ds = state.object as! Bool
        self.setNavigationBarHidden(ds, animated: true)
    }
    
    func leftEdgeDismissal(_ sender : UIScreenEdgePanGestureRecognizer){
        let percentThreshold:CGFloat = 0.7
        let translation = sender.translation(in: view)
        let horizontalMovement = translation.x / view.bounds.width
        let leftMovement = fmaxf(Float(horizontalMovement), 0.0)
        let leftMovementPercent = fminf(leftMovement, 1.0)
        let progress = CGFloat(leftMovementPercent)
        
        guard  let interactor = interactor else {return}
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
