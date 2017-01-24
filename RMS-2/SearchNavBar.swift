//
//  SearchNavBar.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit

protocol SearchNavBarDelegate {
    func cancleBtnClicked()
    func searchTextDidChange(text : String)
}

class SearchNavBar: UIView,UISearchBarDelegate {

    var delegate : SearchNavBarDelegate?
    
    lazy var searchBox: UISearchBar = {
        let width = (self.frame.width * 0.8) - 8
        let sb = UISearchBar.init(frame: CGRect.init(x: 8, y: 0, width: width, height: self.frame.height))
        sb.searchBarStyle = .minimal
        sb.placeholder = "Search.."
        return sb
    }()
    
    lazy var cancleBtn: UIButton = {
        let width = (self.frame.width * 0.2)
        let btn = UIButton.init(frame: CGRect.init(x: self.searchBox.frame.maxX, y: 0, width: width, height: self.frame.height))
        btn.setTitle("Cancle", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
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
        delegate?.searchTextDidChange(text: searchBar.text!)
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
        delegate?.cancleBtnClicked()
    }

}
