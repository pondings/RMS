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

class MainOrder: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,OrderMenuDelegate {
    
    fileprivate var isViewInit : Bool = false
    private let menuList = ["OrderMenuList","OrderList","OrderPhoto","OrderPromotion","OrderFeedback"]
    private var views = [UIView]()
    private var currentIndex : Int = 0
    internal var currestRestaurant : Restaurant? = nil
    
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
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let size = CGSize.init(width: self.view.frame.width, height: self.view.frame.height - (self.mainMenu.frame.size.height + (self.navigationController?.navigationBar.frame.height)!))
        let origin = CGPoint.init(x: 0, y: self.mainMenu.frame.maxY)
        let cv = UICollectionView.init(frame: CGRect.init(origin: origin, size: size), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.isDirectionalLockEnabled = true
        cv.bounces = false
        cv.backgroundColor = Color.grey.lighten1
        return cv
    }()
    
    lazy var mainMenu : OrderMenu = {
        let cv = OrderMenu.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: self.view.frame.width, height: self.view.frame.height * 0.07)))
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(mainMenu)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        view.addSubview(collectionView)
        
        for item in menuList {
            let storyboard = self.storyboard!
            let vc = storyboard.instantiateViewController(withIdentifier: item)
            self.addChildViewController(vc)
            let size = CGSize.init(width: self.view.frame.width, height: collectionView.frame.height)
            let origin = CGPoint.init(x: 0, y: 0)
            vc.view.frame = CGRect.init(origin: origin, size: size)
            vc.didMove(toParentViewController: self)
            views.append(vc.view)
        }
        actionSheetTitle.configureActionSheet(SheetStyle: .MainOrder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let nav = self.navigationController as? MainNavbarCtrl {
            nav.isBackButtonHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.addSubview(views[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width, height: collectionView.frame.height)
    }
    
    func didSelectAtIndex(index: IndexPath) {
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollIndex = Int(round(scrollView.contentOffset.x / self.view.bounds.width))
        currentIndex = scrollIndex
        mainMenu.didSelectedIndexPath(indexPath: IndexPath.init(row: scrollIndex, section: 0))
    }
    
    func searchContent(searchText text : String){
        if let vc = self.childViewControllers[currentIndex] as? OrderMenuList {
            vc.searchMenuList(searchText: text)
        }
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
