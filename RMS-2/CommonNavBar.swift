//
//  CommonNavBar.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit

protocol CommonNavBarDelegate {
    func searchBtnClicked()
    func moreBtnClicked()
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
        lb.text = "Test Application"
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(moreBtn)
        self.addSubview(searchBtn)
        self.addSubview(titleLB)
        NotificationCenter.default.addObserver(self, selector: #selector(title4NavBar(notification:)), name: Notification.Name("navTitle"), object: nil)
    }
    
    func title4NavBar(notification : Notification){
        let title = notification.object as! String
        self.titleLB.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchBtnClicked(){
        delegate?.searchBtnClicked()
    }
    
    func moreBtnClicked(){
        delegate?.moreBtnClicked()
    }
    
}
