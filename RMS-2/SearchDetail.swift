//
//  SearchDetail.swift
//  RMS-2
//
//  Created by Pondz on 1/24/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Alamofire
import Material

class SearchDetail: UIViewController,SearchNavBarDelegate {
    
    lazy var leftEdgeScreenGesture : UIScreenEdgePanGestureRecognizer = {
        let lg = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(leftEdgeDisMiss(_:)))
        lg.edges = .left
        return lg
    }()
    
    lazy var suggestCollection: SuggestCollection = {
        let size = CGSize.init(width: self.view.frame.width, height: self.view.height * 0.13)
        let origin = CGPoint.init(x: 0, y: ((self.navigationController?.navigationBar.frame.maxY)!) + 8)
        let sg = SuggestCollection.init(frame: CGRect.init(origin: origin, size: size))
        return sg
    }()
    
    lazy var mainNavBar : MainNavbarCtrl = self.navigationController as! MainNavbarCtrl
    
    var interactor : Interactor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.grey.lighten1
        self.view.addGestureRecognizer(leftEdgeScreenGesture)
        mainNavBar.searchNavBar.delegate = self
        self.view.addSubview(suggestCollection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("hideQR"), object: true)
        NotificationCenter.default.post(name: Notification.Name("dsNavBar"), object: false)
    }
    
    func searchBarDidEnter(text: String) {
    }
    
    func cancleBtnClicked() {
        mainNavBar.cancleBtnClicked()
    }
    
    func leftEdgeDisMiss(_ sender : UIScreenEdgePanGestureRecognizer){
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
            mainNavBar.popViewController(animated: true)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStart = false
            interactor.cancel()
        case .ended:
            interactor.hasStart = false
            if(interactor.shouldFinish) { interactor.finish() ; mainNavBar.cancleBtnClicked() }
            else { interactor.cancel() }
        default:
            break
        }
    }
    
}
