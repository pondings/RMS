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
    
    internal var style : sheetStyle? = nil
    var orderList : [Dictionary<String,AnyObject>]! = []
    var isSelfInit : Bool = false
    
    var delegate : ActionSheetTitleDelegate?
    
    lazy var firPath: FIRDatabaseReference = {
        let ref = FIRDatabase.database().reference().child("Order").child("first").child("qr001")
        return ref
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

