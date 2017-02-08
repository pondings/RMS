//
//  MenuListVC.swift
//  UI-Test
//
//  Created by Pondz on 12/26/2559 BE.
//  Copyright © 2559 Pondz. All rights reserved.
//

import UIKit
import Material
import Alamofire
import FirebaseDatabase
import Kingfisher
import SnapKit

protocol MenuAdded {
    func getMenu(menu : OrderMenuListCell)
}

class OrderMenuList: UIViewController,DataManagentDelegate,UITableViewDataSource,UITableViewDelegate,MenuAdded {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var ref : FIRDatabaseReference!
    private let titleHeader = ["Suggestion!","Poppular!"]
    private var suggestMenu : [Dictionary<String,AnyObject>]! = []
    private var poppularMenu : [Dictionary<String,AnyObject>]! = []
    private var suggestMenuFiltered : [Dictionary<String,AnyObject>]! = []
    private var poppularMenuFiltered : [Dictionary<String,AnyObject>]! = []
    private var isSearchMode : Bool = false
    private var currentIndexPath : Int?
    private var oldIndexPath : Int?
    private var initView : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        configureAlamoFire(path: "Menu", downloadComplete: { result in
            for item in result {
                if((item["suggestion"] as? Bool) != nil && item["suggestion"] as! Bool) {self.suggestMenu.append(item)}
                else {self.poppularMenu.append(item)}
            }
            self.tableView.reloadData()
        })
    }
    
    private func customize(){
        self.view.backgroundColor = Color.grey.lighten1
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Color.grey.lighten1
        tableView.contentInset.bottom = 28
    }

    func getMenu(menu: OrderMenuListCell) {
        var addValue = [String:AnyObject]()
        addValue["ord_name"] = menu.title.text as AnyObject?
        addValue["ord_img"] = menu.menuImageUrl as AnyObject?
        addValue["ord_total"] = 1 as AnyObject?
        addValue["ord_totalPrice"] = Int.init(menu.price.text!.digits) as AnyObject?
        addValue["ord_price"] = Int.init(menu.price.text!.digits) as AnyObject?
        let menuTitle = addValue["ord_name"] as! String
        ref = FIRDatabase.database().reference()
        let refAdd = ref.child("Order").child("first").child("qr001").child(menuTitle)
        refAdd.observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            if let snapDict = snapshot.value as? Dictionary<String,AnyObject> {
                let orderTotal = ((snapDict["ord_total"] as! Int) + 1) as AnyObject?
                let orderTatalPrice = ((snapDict["ord_totalPrice"] as! Int) + (snapDict["ord_price"] as! Int)) as AnyObject?
                addValue["ord_total"] = orderTotal
                addValue["ord_totalPrice"] = orderTatalPrice
            }
            refAdd.setValue(addValue)
        })
    }
    
    func searchMenuList(searchText text : String){
        suggestMenuFiltered = suggestMenu.filter({
            if(text != ""){
                let menuTitle = $0["menu_name"] as! String
                self.isSearchMode = true
                return (menuTitle.range(of: text) != nil)
            }else{ self.isSearchMode = false ; return (suggestMenu != nil) }
        })
        poppularMenuFiltered = poppularMenu.filter({
            if(text != ""){
                let title = $0["menu_name"] as! String
                self.isSearchMode = true
                return (title.range(of: text) != nil)
            }else{
                self.isSearchMode = false
                return false
            }
        })
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let total = section == 0 ? (isSearchMode ? suggestMenuFiltered.count : suggestMenu.count) : (isSearchMode ? poppularMenuFiltered.count : poppularMenu.count)
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrderMenuListCell
        let menuDict = indexPath.section == 0 ? (isSearchMode ? suggestMenuFiltered : suggestMenu) : (isSearchMode ? poppularMenuFiltered : poppularMenu)
        let menu = Menus.init(menuDict: (menuDict?[indexPath.row])!)
        cell.configureCell(menu: menu)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height * 0.15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSectionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        let title = UILabel.init(frame: CGRect.init(x: 8, y: (headerSectionView.frame.height / 2) - 11, width: tableView.frame.width / 2, height: 30))
        title.text = titleHeader[section]
        title.textColor = .white
        headerSectionView.addSubview(title)
        headerSectionView.backgroundColor = Color.lightBlue.base
        return headerSectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.frame.height * 0.07
    }
}

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

