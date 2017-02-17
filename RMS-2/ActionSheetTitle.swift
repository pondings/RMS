//
//  ActionSheetTitle.swift
//  RMS-2
//
//  Created by Pondz on 2/8/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import SnapKit
import Material
import FirebaseDatabase
import FBSDKLoginKit

protocol ActionSheetTitleDelegate {
    func cancelOrderButtonClicked()
    func confirmOrderButtonClicked()
}

extension ActionSheetTitleDelegate where Self : MainOrder {
    
    func cancelOrderButtonClicked(){}
    
    func confirmOrderButtonClicked(){}
}

class ActionSheetTitle: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    internal var style : sheetStyle? = nil
    internal var orderList : [Dictionary<String,AnyObject>]! = []
    internal var isSelfInit : Bool = false
    
    var delegate : ActionSheetTitleDelegate?
    
    fileprivate lazy var firPath: FIRDatabaseReference = {
        let ref = FIRDatabase.database().reference().child("Order").child("first").child("qr001")
        return ref
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset.top = 8
        layout.sectionInset.bottom = 8
        let cv = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = Color.grey.lighten1
        return cv
    }()
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel.init()
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView.init(frame: CGRect.init())
        return iv
    }()
    
    lazy var submitButton: FlatButton = {
        let btn = FlatButton.init()
        btn.setTitle("Confirm", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(submitOrderClicked), for: .touchUpInside)
        btn.backgroundColor = Color.lightBlue.base
        btn.pulseColor = .white
        return btn
    }()
    
    lazy var cancelButton: FlatButton = {
        let btn = FlatButton.init()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(cancelOrderClicked), for: .touchUpInside)
        btn.backgroundColor = Color.red
        btn.pulseColor = .white
        return btn
    }()
    
    enum sheetStyle : Int{
        case MainRestaurant = 0
        case MainOrder = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    func configureActionSheet(SheetStyle style : sheetStyle){
        switch style {
        case .MainRestaurant:
            self.style = .MainRestaurant
            configureMainRestaurant()
        case .MainOrder:
            self.style = .MainOrder
            collectionView.register(ActionSheetCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            configureMainOrder()
        }
    }
    
    private func configureMainRestaurant(){
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
        request?.start(completionHandler: { (_, result, _) in
            guard
                let info = result as? NSDictionary,
                let picture = info.value(forKey: "picture") as? NSDictionary,
                let data = picture.value(forKey: "data") as? NSDictionary,
                let url = data.value(forKey: "url") as? String
                else {return}
            self.configureImageView(url: url)
            self.configureTitleLabel(title: info.value(forKey: "name") as! String)
            self.imageView.snp.makeConstraints { (make) in
                make.top.bottom.leading.equalToSuperview()
                make.width.equalTo(self.frame.width * 0.5)
            }
            self.titleLabel.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(8)
                make.left.equalTo(self.imageView.snp.right)
                make.trailing.equalToSuperview()
            })
        })
    }
    
    private func configureTitleLabel(title : String){
        titleLabel.text = title
        self.addSubview(titleLabel)
    }
    
    private func configureImageView(url : String){
        let urlPath = URL.init(string: url)
        imageView.kf.setImage(with: urlPath)
        self.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ActionSheetTitle {
    
    internal func configureMainOrder(){
        if(style == .MainOrder){
            self.addSubview(collectionView)
            collectionView.snp.makeConstraints({ (make) in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(self.snp.height).offset( -self.frame.height * 0.1)
            })
            self.addSubview(submitButton)
            submitButton.snp.makeConstraints({ (make) in
                make.top.equalTo(collectionView.snp.bottom)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(self.frame.height * 0.05)
            })
            self.addSubview(cancelButton)
            cancelButton.snp.makeConstraints({ (make) in
                make.top.equalTo(submitButton.snp.bottom)
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            })
        }
    }
    
    
    func submitOrderClicked(){
        self.delegate?.confirmOrderButtonClicked()
    }
    
    func cancelOrderClicked(){
        self.delegate?.cancelOrderButtonClicked()
    }
    
    func userCancelOrder(){
        firPath.removeValue()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ActionSheetCollectionViewCell
        let order = orderList[indexPath.row]
        cell.configureCell(Order: Order.init(orderDict: order))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width - 20, height: collectionView.frame.height * 0.25)
    }
    
    func configureFirebase(){
        if(isSelfInit) {return}
        firPath.observe(.childAdded, with: { [weak self] (snap) -> Void in
            guard
                let strongSelf = self,
                let data = snap.value as? Dictionary<String,AnyObject>
                else {return}
            strongSelf.orderList.append(data)
            strongSelf.collectionView.reloadData()
        })
        firPath.observe(.childChanged, with: { [weak self] (snap) -> Void in
            guard
                let strongSelf = self,
                let data = snap.value as? Dictionary<String,AnyObject>
                else {return}
            let changeData = Order.init(orderDict: data)
            for (index,element) in strongSelf.orderList.enumerated() {
                let currentElement = Order.init(orderDict: element)
                if(changeData.menuTitle! == currentElement.menuTitle!){
                    strongSelf.orderList[index] = data
                    strongSelf.collectionView.reloadData()
                }
            }
        })
        firPath.observe(.childRemoved, with: {[weak self] (snap) -> Void in
            guard
                let strongSelf = self ,
                let data = snap.value as? Dictionary<String,AnyObject>
                else {return}
            let removeData = Order.init(orderDict: data)
            for (index,element) in strongSelf.orderList.enumerated(){
                let currentElement = Order.init(orderDict: element)
                if(removeData.menuTitle! == currentElement.menuTitle!){
                    strongSelf.orderList.remove(at: index)
                    strongSelf.collectionView.reloadData()
                }
            }
        })
        isSelfInit = true
    }
}


