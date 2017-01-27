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

class SearchDetail: UIViewController,SearchNavBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SuggestMenuDelegate {
    
    let menuList = ["Recommend_PT","Nearby_PT","Facebook_PT","Twitter_PT","Apple_PT"]
    var views = [UIView]()
    var interactor : Interactor? = nil
    
    lazy var leftEdgeScreenGesture :UIScreenEdgePanGestureRecognizer = {
        let lg = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(leftEdgeDisMiss(_:)))
        lg.edges = .left
        return lg
    }()
    
    lazy var suggestCollection: SuggestCollection = {
        let size = CGSize.init(width: self.view.frame.width, height: self.view.height * 0.13)
        let origin = CGPoint.init(x: 0, y: ((self.navigationController?.navigationBar.frame.maxY)!) + 8)
        let sg = SuggestCollection.init(frame: CGRect.init(origin: origin, size: size))
        sg.delegate = self
        return sg
    }()

    
    lazy var collectionView: UICollectionView = {
        let height = (self.view.frame.height - self.suggestCollection.frame.height) - ((self.navigationController?.navigationBar.frame.height)! + (self.navigationController?.tabBarController?.tabBar.frame.height)!)
        let size = CGSize.init(width: UIScreen.main.bounds.width, height: CGFloat(height - 40) )
        let origin = CGPoint.init(x: 0, y: self.suggestCollection.frame.maxY + 4)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView.init(frame: CGRect.init(origin: origin, size: size), collectionViewLayout: layout)
        cv.backgroundColor = Color.grey.lighten1
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.bounces = false
        cv.isPagingEnabled = true
        cv.isDirectionalLockEnabled = true
        return cv
    }()
    
    lazy var mainNavBar : MainNavbarCtrl = self.navigationController as! MainNavbarCtrl

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        view.backgroundColor = Color.grey.lighten1
        navigationController?.navigationBar.addGestureRecognizer(leftEdgeScreenGesture)
        mainNavBar.searchNavBar.delegate = self
        view.addSubview(suggestCollection)
        view.addSubview(collectionView)

        for item in menuList {
            let storyboard = self.storyboard!
            let vc = storyboard.instantiateViewController(withIdentifier: item)
            self.addChildViewController(vc)
            vc.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width , height: collectionView.frame.height)
            vc.didMove(toParentViewController: self)
            views.append(vc.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.frame.origin.y = 0
        NotificationCenter.default.post(name: Notification.Name("hideQR"), object: true)
        NotificationCenter.default.post(name: Notification.Name("dsNavBar"), object: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.addSubview(views[indexPath.row])
        cell.contentView.addGestureRecognizer(leftEdgeScreenGesture)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width , height: collectionView.frame.height)
    }
    
    func didSelectedMunu(at index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollIndex = Int(round(scrollView.contentOffset.x / self.view.bounds.width))
        suggestCollection.configureWhiteView(index: scrollIndex)
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
