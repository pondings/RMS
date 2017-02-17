//
//  OrderMenuListCell.swift
//  RMS-2
//
//  Created by Pondz on 2/10/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import Kingfisher

class OrderMenuListCell: UITableViewCell {
    
    var delegate : MenuAdded?
    var menuImageUrl : String?
    var menuPrice : Double?
    
    lazy var imageViewCell: UIImageView = {
        let iv = UIImageView.init(frame: CGRect.init())
        return iv
    }()
    
    lazy var title: UILabel = {
        let lb = UILabel.init(frame: CGRect.init())
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var desc: UILabel = {
        let lb = UILabel.init(frame: CGRect.init())
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.alpha = 0.6
        return lb
    }()
    
    lazy var price: UILabel = {
        let lb = UILabel.init(frame: CGRect.init())
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.alpha = 0.6
        return lb
    }()
    
    lazy var addBtn: FlatButton = {
        let btn = FlatButton.init(frame: CGRect.init())
        btn.backgroundColor = Color.lightBlue.base
        btn.setTitle("Add", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(addMenu), for: .touchUpInside)
        btn.pulseColor = .white
        return btn
    }()
    
    func configureCell(menu : Menu){
        self.selectionStyle = .none
        menuImageUrl = menu.menuImageUrl!
        menuPrice = menu.menuPrice!
        configureImageView(url: menu.menuImageUrl!)
        configureTitle(title: menu.menuTitle!)
        configureDesc(desc: menu.menuDetail!)
        configurePrice(price: menu.menuPrice!)
        configureAddButton()
        configureConstraints()
    }
    
    private func configureAddButton(){
        self.addSubview(addBtn)
    }
    
    private func configurePrice(price : Double){
        self.price.text = "\(price) ฿"
        self.addSubview(self.price)
    }
    
    private func configureDesc(desc : String){
        self.desc.text = desc
        self.addSubview(self.desc)
    }
    
    private func configureTitle(title : String){
        self.title.text = title
        self.addSubview(self.title)
    }
    
    private func configureImageView(url : String) {
        let urlPath = URL.init(string: url)
        imageViewCell.kf.setImage(with: urlPath)
        self.addSubview(imageViewCell)
    }
    
    private func configureConstraints(){
        imageViewCell.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(8)
            make.left.equalTo(self.imageViewCell.snp.right).offset(8)
        }
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(self.title.snp.bottom).offset(8)
            make.left.equalTo(self.imageViewCell.snp.right).offset(8)
            make.centerY.equalTo(self.imageViewCell.snp.centerY)
        }
        price.snp.makeConstraints { (make) in
            make.top.equalTo(self.desc.snp.bottom).offset(8)
            make.left.equalTo(self.imageViewCell.snp.right).offset(8)
            make.centerY.equalTo(self.imageViewCell.snp.bottom).offset(-16)
        }
        addBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-4)
            make.top.equalTo(price).offset(-8)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    func addMenu(){
        delegate?.getMenu(menu: self)
    }
    
}

