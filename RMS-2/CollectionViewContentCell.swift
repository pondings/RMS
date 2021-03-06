//
//  CollectionViewCell.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material

class RestaurantListCell: UICollectionViewCell {
    
    lazy var image: UIImageView = {
        let height = self.frame.height * 0.6
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width , height: height))
        return img
    }()
    
    lazy var title: UILabel = {
        let yPosition = self.image.frame.height + 8
        let height = self.frame.height * 0.1
        let width = (self.frame.width * 0.9) - 8
        let lb = UILabel.init(frame: CGRect.init(x: 8, y: yPosition, width: width, height: height))
        return lb
    }()
    
    lazy var bookmarkBtn: FlatButton = {
        let xPosition = self.title.frame.maxX
        let yPosition = self.image.frame.maxY + 8
        let width = self.frame.width * 0.1
        let height = self.frame.height * 0.1
        let btn = FlatButton.init(frame: CGRect.init(x: xPosition, y: yPosition, width: width, height: height))
        btn.tintColor = .black
        btn.alpha = 0.5
        btn.pulseColor = .blue
        btn.cornerRadius = height / 2
        btn.setImage(UIImage.init(named: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        return btn
    }()
    
    lazy var desc: UILabel = {
        let yPosition = self.title.frame.maxY
        let height = self.frame.height * 0.17
        let lb = UILabel.init(frame: CGRect.init(x: 8, y: yPosition, width: self.frame.width - 16, height: height))
        return lb
    }()
    
    lazy var subTitle: UILabel = {
        let yPosition = self.desc.frame.maxY
        let xPosition = self.subBtn.frame.maxX
        let height = self.frame.height * 0.1
        let lb = UILabel.init(frame: CGRect.init(x: xPosition , y: yPosition, width: self.frame.width, height: height))
        return lb
    }()
    
    lazy var subBtn: FlatButton = {
        let yPosition = self.desc.frame.maxY
        let height = self.frame.height * 0.1
        let width = height
        let btn = FlatButton.init(frame: CGRect.init(x: 0, y: yPosition, width: width, height: height))
        btn.tintColor = .black
        btn.alpha = 0.5
        btn.cornerRadius = height / 2
        btn.pulseColor = .blue
        btn.addTarget(self, action: #selector(subBtnClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    func configureCell(restaurant : Restaurant){
        configureTitle(title: restaurant.restaurantTitle!)
        configureDesc(desc: restaurant.restaurantDetail!)
        configureSubBtn(image: "location")
        configureSubTitle(st: restaurant.locationTitle!)
        configureLayout()
    }
    
    func configureCell(mostView : MostView){
        configureTitle(title: mostView.mostViewTitle!)
        configureDesc(desc: mostView.mostViewDetail!)
        configureSubBtn(image: "period")
        configureSubTitle(st: mostView.locationTitle!)
        configureLayout()
    }
    
    func configureCell(promotion : Promotion){
        configureTitle(title: promotion.promotionTitle!)
        configureDesc(desc: promotion.promotionDetail!)
        configureSubBtn(image: "period")
        configureSubTitle(st: promotion.promotionPeriod!)
        configureLayout()
    }
    
    private func configureLayout(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        configureBookmark()
    }
    
    private func configureBookmark(){
        self.addSubview(bookmarkBtn)
    }
    
    private func configureSubBtn(image : String){
        subBtn.setImage(UIImage.init(named: image)?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.addSubview(subBtn)
    }
    
    private func configureTitle(title : String){
        self.title.text = title
        self.title.font = self.title.font.withSize(13)
        self.addSubview(self.title)
    }
    
    private func configureDesc(desc: String) {
        self.desc.text = desc
        self.desc.font = self.desc.font.withSize(13)
        self.desc.alpha = 0.5
        self.desc.numberOfLines = 0
        self.addSubview(self.desc)
    }
    
    private func configureSubTitle(st : String){
        subTitle.text = st
        subTitle.font = subTitle.font.withSize(13)
        subTitle.alpha = 0.5
        self.addSubview(subTitle)
    }
    
    func subBtnClicked(_ sender : UIButton){
        print("Open map!")
    }
    
    func configreImage(image : UIImage){
        self.image.image = image
        self.addSubview(self.image)
    }
    
    func configureImage(url : String) {
        let urlPath = URL.init(string: url)
        image.kf.setImage(with: urlPath)
        self.addSubview(image)
    }
    
}
