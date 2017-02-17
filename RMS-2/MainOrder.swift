//
//  MainOrder.swift
//  RMS-2
//
//  Created by Pondz on 1/27/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import AFMActionSheet
import FBSDKLoginKit

class MainOrder: UITabBarController,UITabBarControllerDelegate{
    
    fileprivate var isViewInit : Bool = false
    var previousViewCntroller : UIViewController? = nil
    
    var actionSheetTitle: ActionSheetTitle = {
        let at = ActionSheetTitle.init(frame: CGRect.init(x: 0, y: 0, width: 500, height: 500))
        return at
    }()
    
    lazy var actionSheet: AFMActionSheetController = {
        let sheet = AFMActionSheetController.init(style: .actionSheet, transitioningDelegate: AFMActionSheetTransitioningDelegate())
        sheet.add(title: self.actionSheetTitle)
        let action1 = AFMAction.init(title: "ตั้งค่า", handler: nil)
        let action2 = AFMAction.init(title: "เกี่ยวกับ", handler: nil)
        let action3 = AFMAction.init(title: "ตั้งค่าบัญชี", handler: { _ in self.AccountManagement() })
        let close = AFMAction.init(title: "ยกเลิก", handler: nil)
        sheet.add(action1)
        sheet.add(action2)
        sheet.add(action3)
        sheet.add(cancelling: close)
        return sheet
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        actionSheetTitle.configureActionSheet(SheetStyle: .MainRestaurant)
        tabBar.barTintColor = Color.lightBlue.base
        statusBar.backgroundColor = Color.lightBlue.base
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let nav = self.navigationController as? MainNavbarCtrl {
            nav.isBackButtonHidden = false
            nav.setNavbarTitle = "Menu List"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        statusBar.backgroundColor = .clear
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.selectedImage = item.image?.tint(with: Color.white)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if(viewController == previousViewCntroller){
            if let vc = self.selectedViewController as? UICollectionViewController{
                if((vc.collectionView?.numberOfItems(inSection: 0))! < 1) {return}
                vc.collectionView?.setContentOffset(CGPoint.zero, animated: true)
            }
        }
        NotificationCenter.default.post(name: Notification.Name("navTitle"), object: viewController.restorationIdentifier!)
        previousViewCntroller = viewController
    }
    
    @IBAction func test(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension MainOrder : ActionSheetTitleDelegate {
    func openActionSheet(){
        actionSheetTitle.delegate = self
        actionSheetTitle.snp.makeConstraints({ (make) in
            make.height.equalTo(self.view.frame.height)
            make.width.equalTo(self.view.frame.width)
        })
        actionSheetTitle.configureFirebase()
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func cancelOrderButtonClicked() {
        self.actionSheet.dismiss(animated: true, completion: nil)
        let alert = UIAlertController.init(title: "Cancel Order?", message: "All list will be remove", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Confirm", style: .destructive, handler: { _ in
            self.actionSheetTitle.userCancelOrder()
            self.openActionSheet()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in self.openActionSheet() }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func confirmOrderButtonClicked() {
        self.actionSheet.dismiss(animated: true, completion: nil)
        let alert = UIAlertController.init(title: "Confirm Order", message: "", preferredStyle: .alert)
        alert.addAction(.init(title: "Confirm", style: .default, handler: {_ in self.actionSheetTitle.userCancelOrder() ; print("Send order to somewhere!")}))
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: {_ in self.openActionSheet()}))
        self.present(alert, animated: true, completion: nil)
    }
}
