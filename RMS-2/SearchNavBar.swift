//
//  SearchNavBar.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

@objc protocol SearchNavBarDelegate {
    @objc optional func cancleBtnClicked()
    @objc optional func searchBarDidEnter(text : String)
}

class SearchNavBar: UIView,UISearchBarDelegate {

    var delegate : SearchNavBarDelegate?
    
    lazy var searchBox: UISearchBar = {
        let width = (self.frame.width - self.cancleBtn.frame.width) - 16
        let sb = UISearchBar.init(frame: CGRect.init(x: self.cancleBtn.frame.maxX, y: 0, width: width, height: self.frame.height))
        sb.searchBarStyle = .minimal
        sb.placeholder = "Search.."
        return sb
    }()
    
    lazy var cancleBtn: UIButton = {
        let width = CGFloat(24)
        let btn = UIButton.init(frame: CGRect.init(x: 8, y: (self.frame.height / 2) - 12, width: width, height: width))
        btn.setFAIcon(icon: FAType.FAChevronLeft, forState: .normal)
        btn.setFATitleColor(color: .white, forState: .normal)
        btn.addTarget(self, action: #selector(cancleBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        searchBox.delegate = self
        self.addSubview(searchBox)
        self.addSubview(cancleBtn)
        customize()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchBarDidEnter!(text: searchBar.text!)
        
    }
    
    private func customize(){
        if let textFieldInsideSearchBar = self.searchBox.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.white
            textFieldInsideSearchBar.backgroundColor = UIColor.white
            if let placeHolderColor = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel {
                placeHolderColor.textColor = UIColor.white
                placeHolderColor.alpha = 0.7
            }
            if let searchIcon = textFieldInsideSearchBar.leftView as? UIImageView {
                searchIcon.image = searchIcon.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                searchIcon.tintColor = UIColor.white
                searchIcon.alpha = 0.5
            }
            if let clearButton = textFieldInsideSearchBar.value(forKey: "clearButton") as? UIButton {
                clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
                clearButton.tintColor = UIColor.white
                clearButton.alpha = 0.7
            }
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancleBtnClicked(){
        delegate?.cancleBtnClicked!()
    }

}
