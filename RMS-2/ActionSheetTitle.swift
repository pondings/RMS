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

@objc protocol ActionSheetTitleDelegate {
    @objc optional func cancelButtonClicked()
    @objc optional func confirmButtonClicked()
}

class ActionSheetTitle: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    private var style : sheetStyle? = nil
    private var orderList : [Dictionary<String,AnyObject>]! = []
    
    var delegate : ActionSheetTitleDelegate?
    
    lazy var firPath: FIRDatabaseReference = {
        let fp = FIRDatabase.database().reference().child("Order").child("first").child("qr001")
        return fp
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset.top = 8
        layout.sectionInset.bottom = 8
        let cv = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = Color.grey.lighten1
        return cv
    }()
    
    lazy var titleLabel: UILabel = {
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
    
    private func configureFirebasae(){
        firPath.observe(.childAdded, with: {[weak self] (snap) -> Void in
            guard
                let strongSelf = self,
                let data = snap.value as? Dictionary<String,AnyObject>
                else{return}
            strongSelf.orderList.append(data)
            strongSelf.collectionView.reloadData()
        })
        firPath.observe(.childChanged, with: { [weak self] (snap) -> Void in
            guard let strongSelf = self else {return}
            let changeValue = snap.value as! Dictionary<String,AnyObject>
            let changeValueDict = Menus.init(ordDict: changeValue)
            for (index,element) in strongSelf.orderList.enumerated() {
                let orderDict = Menus.init(ordDict: element)
                if(orderDict.title! == changeValueDict.title!){
                    if let cell = strongSelf.collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) as? ActionSheetCollectionViewCell{
                        cell.configureCell(Order: changeValueDict)
                    }
                }
            }
        })
        firPath.observe(.childRemoved, with: { [weak self] (snap) -> Void in
            guard let strongSelf = self else{return}
            let removeValue = snap.value as! Dictionary<String,AnyObject>
            let removeValueDict = Menus.init(ordDict: removeValue)
            for (index,element) in strongSelf.orderList.enumerated() {
                let orderDict = Menus.init(ordDict: element)
                if(orderDict.title! == removeValueDict.title!) {
                    print("Base Element \(element)")
                    print("Index : \(index)")
                    print("remove val :  \(removeValueDict)")
                    print("orderList : \(strongSelf.orderList)")
                    strongSelf.orderList.remove(at: index)
                    strongSelf.collectionView.deleteItems(at: [IndexPath.init(row: index, section: 0)])
                }
            }
        })
    }
    
    func configureActionSheet(SheetStyle style : sheetStyle){
        switch style {
        case .MainRestaurant:
            self.style = .MainRestaurant
            configureMainRestaurant()
            print("Main Restaurant Style!")
        case .MainOrder:
            self.style = .MainOrder
            collectionView.register(ActionSheetCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            configureMainOrder()
            print("Main Order Style!")
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
            print("Success")
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
    
    private func configureMainOrder(){
        if(style == .MainOrder){
            configureFirebasae()
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
        self.delegate?.confirmButtonClicked!()
    }
    
    func cancelOrderClicked(){
        self.delegate?.cancelButtonClicked!()
    }
    
    func removeAllContentInCollectionView(){
        firPath.removeValue()
        orderList.removeAll()
        collectionView.reloadData()
    }
    
    func reloadAllContent(){
        orderList.removeAll()
        collectionView.reloadData()
        configureFirebasae()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ActionSheetCollectionViewCell
        let order = orderList[indexPath.row]
        cell.configureCell(Order: Menus.init(ordDict: order))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width - 20, height: collectionView.frame.height * 0.25)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

