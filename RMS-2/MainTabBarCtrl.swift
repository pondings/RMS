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
import AFMActionSheet
import FacebookLogin
import Kingfisher

class MainTabBarCtrl: UITabBarController,UITabBarControllerDelegate,QRButtonDelegate,QRReaderDelegate {
    
    @IBOutlet weak var titleView : UIView!
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var nameLb : UILabel!
    
    var previousViewCntroller : UIViewController? = nil
    var interactor = Interactor()
    
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
        btn.delegate = self
        return btn
    }()
    
    lazy var actionSheet: AFMActionSheetController = {
        let sheet = AFMActionSheetController.init(style: .actionSheet, transitioningDelegate: AFMActionSheetTransitioningDelegate())
        let action1 = AFMAction.init(title: "ตั้งค่า", handler: nil)
        let action2 = AFMAction.init(title: "เกี่ยวกับ", handler: nil)
        let action3 = AFMAction.init(title: "ตั้งค่า Account", handler: { _ in self.AccountManagement() })
        let close = AFMAction.init(title: "ยกเลิก", handler: nil)
        sheet.add(action1)
        sheet.add(action2)
        sheet.add(action3)
        sheet.add(cancelling: close)
        return sheet
    }()
    
    lazy var actionSheetTitle: ActionSheetTitle = {
        let at = ActionSheetTitle.init(frame: CGRect.init())
        return at
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        view.addSubview(lightBlueView)
        tabBar.barTintColor = Color.lightBlue.base
        view.backgroundColor = .white
        view.addSubview(qrBtn)
        NotificationCenter.default.addObserver(self, selector: #selector(hideQRBtn(notification:)), name: Notification.Name("hideQR"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moreBtnClicked), name: Notification.Name("activeActionSheet"), object: nil)
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
            if((VC?.collectionView?.numberOfItems(inSection: 0))! < 1) {return}
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
    
    func moreBtnClicked() {
        if(FBSDKAccessToken.current() != nil){
            actionSheetTitle.configureActionSheet(SheetStyle: .MainRestaurant)
            actionSheetTitle.snp.makeConstraints { (make) in
                make.height.equalTo(self.view.frame.height * 0.25)
            }
            actionSheet.add(title: actionSheetTitle)
        }else {
            actionSheet.add(title: UIView())
        }
        self.present(actionSheet, animated: true, completion: nil)
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
