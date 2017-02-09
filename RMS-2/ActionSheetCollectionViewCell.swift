//
//  ActionSheetCollectionViewCell.swift
//  RMS-2
//
//  Created by Pondz on 2/9/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import SnapKit
import Kingfisher

class ActionSheetCollectionViewCell: UICollectionViewCell {
    
    var totalPrcie : Int? = nil
    var urlImage : String? = nil
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView.init()
        return iv
    }()
    
    lazy var orderTitle: UILabel = {
        let lb = UILabel.init()
        lb.font = lb.font.withSize(13)
        return lb
    }()
    
    lazy var orderQuantity: UILabel = {
        let lb = UILabel.init()
        lb.alpha = 0.5
        lb.font = lb.font.withSize(13)
        return lb
    }()
    
    lazy var orderTotal: UILabel = {
        let lb = UILabel.init()
        lb.alpha = 0.5
        lb.font = lb.font.withSize(13)
        lb.textAlignment = .left
        return lb
    }()
    
    func configureCell(Order order : Menu){
        self.backgroundColor = .white
        configureImageView(url: order.img!)
        configureTitleLabel(title: order.title!)
        configureQuantityLabel(quantity: order.quantity!)
        configureTotalLabel(quantity: order.quantity!, price: order.price!)
        configureConstraints()
    }
    
    private func configureTotalLabel(quantity : String ,price : Int){
        orderTotal.text = "Total Price: \(price * Int(quantity)!) ฿"
        self.addSubview(orderTotal)
    }
    
    private func configureQuantityLabel(quantity : String){
        orderQuantity.text = "Total : \(quantity)"
        self.addSubview(orderQuantity)
    }
    
    private func configureTitleLabel(title : String){
        orderTitle.text = title
        self.addSubview(orderTitle)
    }
    
    private func configureImageView(url : String){
        let urlPath = URL.init(string: url)
        imageView.kf.setImage(with: urlPath)
        self.addSubview(imageView)
    }
    
    private func configureConstraints(){
        imageView.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(self.frame.width * 0.5)
        }
        orderTitle.snp.makeConstraints { (make) in
            make.width.equalTo(self.frame.width * 0.4)
            make.height.equalTo(self.frame.height * 0.1)
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(imageView.snp.right).offset(8)
        }
        orderQuantity.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.centerY).offset(-orderQuantity.frame.height / 2)
            make.left.equalTo(orderTitle.snp.left)
            make.height.width.equalTo(orderTitle)
        }
        orderTotal.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset((orderTotal.frame.height / 2) - 16)
            make.left.equalTo(orderQuantity)
            make.height.width.equalTo(orderTitle).offset(5)
        }
    }
    
}

