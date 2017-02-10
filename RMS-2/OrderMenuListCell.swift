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
    
    lazy var imageViewCell: UIImageView = {
        let size = CGSize.init(width: self.frame.width * 0.4, height: self.frame.height)
        let origin = CGPoint.init(x: 0, y: 0)
        let iv = UIImageView.init(frame: CGRect.init(origin: origin, size: size))
        return iv
    }()
    
    lazy var title: UILabel = {
        let lb = UILabel.init(frame: CGRect.init(x: self.imageViewCell.frame.width + 10, y: self.frame.height * (1/3), width: self.frame.width * 0.4, height: self.frame.height * 0.2))
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var desc: UILabel = {
        let lb = UILabel.init(frame: CGRect.init(x: self.imageViewCell.frame.width + 10, y: self.frame.height * (2/3), width: self.frame.width * 0.4, height: self.frame.height * 0.25))
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.alpha = 0.6
        return lb
    }()
    
    lazy var price: UILabel = {
        let lb = UILabel.init(frame: CGRect.init(x: self.imageViewCell.frame.width + 10, y: self.frame.height * (3/3), width: self.frame.width * 0.4, height: self.frame.height * 0.25))
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var addBtn: FlatButton = {
        let yPosition = self.frame.height * 0.7
        let xPosition = self.frame.width - (self.frame.width * 0.2)
        let btn = FlatButton.init(frame: CGRect.init(x: xPosition - 8, y: yPosition - 8, width: self.frame.width * 0.2, height: self.frame.height * 0.3))
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
        menuImageUrl = menu.img!
        configureImageView(url: menu.img!)
        configureTitle(title: menu.title!)
        configureDesc(desc: menu.desc!)
        configurePrice(price: menu.price!)
        configureAddButton()
        configureConstraints()
    }
    
    private func configureAddButton(){
        self.addSubview(addBtn)
    }
    
    private func configurePrice(price : Int){
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
            make.width.equalTo(self.frame.width * 0.4)
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
            make.centerY.equalTo(self.price.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-16)
            make.width.equalTo(self.frame.width * 0.25)
        }
    }
    
    func addMenu(){
        delegate?.getMenu(menu: self)
    }
    
}

