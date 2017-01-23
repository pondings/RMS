//
//  EmptyData.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material

class EmptyData: UIView {
    
    lazy var refreshBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        return btn
    }()
    
    lazy var descLb: UILabel = {
        let lb = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        return lb
    }()
    
    lazy var titleLb: UILabel = {
        let lb = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        return lb
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        return iv
    }()

    enum state {
        case connectonError
        case emptyData
        case notFoundContent
        case isLoading
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.grey.lighten1
    }
    
    func emptyState(state : state){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
