//
//  EmptyData.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import Alamofire

@objc protocol DataManagentDelegate {
    @objc optional func showConnectionError(emptyData : UIView)
}

class DataManagent: UIView {
    
    var delegate : DataManagentDelegate?
    
    lazy var refreshBtn: UIButton = {
        let width = self.frame.width * 0.4
        let height = self.frame.height * 0.1
        let xPosition = ((self.frame.width / 2) - (width / 2))
        let yPosition = self.titleLb.frame.maxY
        let btn = UIButton.init(frame: CGRect.init(x: xPosition, y: yPosition, width: width, height: height))
        btn.setTitleColor(Color.lightBlue.base, for: .normal)
        btn.addTarget(self, action: #selector(refreshBtnClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLb: UILabel = {
        let width = self.frame.width
        let height = self.frame.height * 0.1
        let xPosition = ((self.frame.width / 2) - (width / 2))
        let yPosition = self.imageView.frame.maxY
        let lb = UILabel.init(frame: CGRect.init(x: xPosition, y: yPosition, width: width, height: height))
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var imageView: UIImageView = {
        let width = self.width * 0.4
        let height = width
        let xPosition = ((self.frame.width / 2) - (height / 2))
        let yPosition = ((self.frame.height * 0.35) - (width / 2))
        let iv = UIImageView.init(frame: CGRect.init(x: xPosition, y: yPosition, width: width, height: height))
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
    
    func emptyState(state : state) {
        switch state {
        case .notFoundContent:
            configureImageView(img: "hungry")
            configureTitle(title: "Not found anything")
            configureRefreshBtn(btn: "Close")
        case .connectonError:
            configureImageView(img: "hungry")
            configureTitle(title: "Connection Error")
            configureRefreshBtn(btn: "Reload again!")
        default:
            break
        }
        
    }
    
    func refreshBtnClicked(_ sender : UIButton){
        sender.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            sender.transform = .identity
        }, completion: nil)
//        delegate?.refreshBtnClicked()
    }
    
    private func configureRefreshBtn(btn : String) {
        refreshBtn.setTitle(btn, for: .normal)
        self.addSubview(refreshBtn)
    }
    
    private func configureImageView(img : String){
        imageView.image = UIImage.init(named: img)
        self.addSubview(imageView)
    }
    
    private func configureTitle(title : String){
        titleLb.text = title
        self.addSubview(titleLb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DataManagentDelegate where Self : UICollectionViewDataSource {
    func configureAlamoFire(path : String,downloadComplete : @escaping DowloadContentComplete){
        Alamofire.request("\(_urlBase)\(path)").responseJSON { response in
            if(response.result.isFailure) { self.connectionError() ; return }
            var dict : [Dictionary<String,AnyObject>]! = []
            let data = response.result.value as! [String:AnyObject]
            for item in data.values{
                dict.append(item as! Dictionary<String,AnyObject>)
            }
            downloadComplete(dict)
        }
    }
    
    func connectionError(){
        
    }
}

extension DataManagentDelegate where Self : UITableViewDataSource {
    func configureAlamoFire(path : String,downloadComplete : @escaping DowloadContentComplete){
        Alamofire.request("\(_urlBase)\(path)").responseJSON { response in
            var dict : [Dictionary<String,AnyObject>]! = []
            let data = response.result.value as! [String:AnyObject]
            for item in data.values{
                dict.append(item as! Dictionary<String,AnyObject>)
            }
            downloadComplete(dict)
        }
    }
    
    
}
