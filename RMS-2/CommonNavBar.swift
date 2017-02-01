//
//  CommonNavBar.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

@objc protocol CommonNavBarDelegate {
    @objc optional func searchBtnClicked()
    @objc optional func moreBtnClicked()
    @objc optional func backButtonClicked()
}

class CommonNavBar: UIView {

    var delegate : CommonNavBarDelegate?
    
    lazy var searchBtn: UIButton = {
        let yPosition = (self.frame.height / 2) - 12
        let xPosition = self.moreBtn.frame.origin.x - 34
        let btn = UIButton.init(frame: CGRect.init(x: xPosition, y: yPosition, width: 24, height: 24))
        btn.setImage(UIImage.init(named: "ic_search")?.tint(with: .white), for: .normal)
        btn.addTarget(self, action: #selector(searchBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var moreBtn: UIButton = {
        let yPosition = (self.frame.height / 2) - 12
        let xPosition = (self.frame.width) - 34
        let btn = UIButton.init(frame: CGRect.init(x: xPosition, y: yPosition, width: 24, height: 24))
        btn.setImage(UIImage.init(named: "ic_more_vert")?.tint(with: .white), for: .normal)
        btn.addTarget(self, action: #selector(moreBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLB: UILabel = {
        let yPosition = (self.frame.height / 2) - 12
        let xPosition = (self.frame.width / 2 ) - 100
        let lb = UILabel.init(frame: CGRect.init(x: xPosition, y: yPosition, width: 200, height: 24))
        lb.text = ""
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var backBtn: UIButton = {
        let size = CGSize.init(width: 24, height: 24)
        let origin = CGPoint.init(x: 8, y: (self.frame.height / 2) - 12)
        let btn = UIButton.init(frame: CGRect.init(origin: origin, size: size))
        btn.isHidden = true
        btn.setFAIcon(icon: FAType.FAChevronLeft, forState: .normal)
        btn.setFATitleColor(color: .white)
        btn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    var showBackButton : Bool {
        get {
            return self.backBtn.isHidden
        }set {
            self.backBtn.isHidden = newValue
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(moreBtn)
        self.addSubview(searchBtn)
        self.addSubview(titleLB)
        self.addSubview(backBtn)
        NotificationCenter.default.addObserver(self, selector: #selector(title4NavBar(notification:)), name: Notification.Name("navTitle"), object: nil)
    }
    
    func title4NavBar(notification : Notification){
        let title = notification.object as! String
        self.titleLB.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func backBtnClicked(){
        delegate?.backButtonClicked!()
    }
    
    func searchBtnClicked(){
        delegate?.searchBtnClicked!()
    }
    
    func moreBtnClicked(){
        delegate?.moreBtnClicked!()
    }
    
}
