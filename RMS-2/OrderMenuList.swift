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

protocol MenuAdded {
    func getMenu(menu : SubMenuTableViewCell)
}

class OrderMenuList: UIViewController,UITableViewDelegate,UITableViewDataSource,MenuAdded,DataManagentDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    
    private var ref : FIRDatabaseReference!
    private var suggestMenu : [Dictionary<String,AnyObject>]! = []
    private var popularMenu : [Dictionary<String,AnyObject>]! = []
    private var suggestMenuFiltered : [Dictionary<String,AnyObject>]! = []
    private var popularMenuFiltered : [Dictionary<String,AnyObject>]! = []
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
                else {self.popularMenu.append(item)}
            }
            self.tableView.reloadData()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(didSearch(notification:)), name: Notification.Name("orderListSearch"), object: nil)
    }
    
    private func customize(){
        self.view.backgroundColor = Color.grey.lighten1
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Color.grey.lighten1
        tableView.bounces = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        cell.configureCell(index:indexPath.row,menuDict: (indexPath.row == 0 ? (isSearchMode ? suggestMenuFiltered : suggestMenu) : popularMenu))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isHide = (UIScreen.main.bounds.height * 0)
        let isShow = ((UIScreen.main.bounds.height * (isSearchMode ? 0.195 : 0.17)) * CGFloat((indexPath.row == 0 ? (isSearchMode ? suggestMenuFiltered.count : suggestMenu.count) : popularMenu.count)) - (isSearchMode ? (suggestMenuFiltered.count == 1 ? 0 : (UIScreen.main.bounds.height * 0.017) * CGFloat(suggestMenuFiltered.count)) : 0))
        if(oldIndexPath != nil && currentIndexPath != nil){
            //Clicked Cell
            if(currentIndexPath == indexPath.row){
                if(oldIndexPath == indexPath.row){
                    oldIndexPath = indexPath.row
                    oldIndexPath = 3
                    return isShow
                }else{
                    oldIndexPath = indexPath.row
                    return isHide
                }
                //Not Clicked Cell
            }
        }
        return isShow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MenuTableViewCell
        cell?.isExpanded = true
        currentIndexPath = indexPath.row
        updateTable()
    }
    
    func updateTable(){
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    func getMenu(menu: SubMenuTableViewCell) {
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
    
    func didSearch(notification : Notification){
        let text = notification.object as! String
        suggestMenuFiltered = suggestMenu.filter({
            if(text != ""){
                let menuTitle = $0["menu_name"] as! String
                self.isSearchMode = true
                return (menuTitle.range(of: text) != nil)
            }else{ self.isSearchMode = false ; return (suggestMenu != nil) }
        })
        tableView.reloadData()
    }
}

class MenuTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    var isExpanded : Bool  = false
    var menuList : [Dictionary<String,AnyObject>]! = []
    
    lazy var titleLb: UILabel = {
        let yPosition = UIScreen.main.bounds.height * 0.005
        let tt = UILabel.init(frame: CGRect.init(x: 10, y: yPosition, width: self.frame.width, height: (UIScreen.main.bounds.height * 0.05)))
        tt.textColor = .white
        return tt
    }()
    lazy var tableView: UITableView = {
        let yPosition = (UIScreen.main.bounds.height * 0.05)
        let tv = UITableView.init(frame: CGRect.init(x: 0, y: yPosition + 5 , width: self.frame.width, height: self.frame.height))
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = Color.grey.lighten1
        tv.tableFooterView = UIView()
        tv.isScrollEnabled = false
        tv.register(SubMenuTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tv
    }()
    
    func configureCell(index:Int,menuDict : [Dictionary<String,AnyObject>]){
        if(index == 0) { titleLb.text = "Suggestion" } else { titleLb.text = "Poppular" }
        self.addSubview(titleLb)
        tableView.height = self.frame.height
        self.addSubview(tableView)
        self.backgroundColor = Color.lightBlue.base
        self.selectionStyle = .none
        self.menuList = menuDict
        tableView.reloadData()
    }
    
    func expandOrCollapse(_ sender : UIButton){
        if(sender.tag == 1)  {
            UIView.animate(withDuration: 0.5, animations: {
                sender.transform = .identity
            })
            sender.tag = 2
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                sender.transform = CGAffineTransform.init(rotationAngle: 0.75)
            })
            sender.tag = 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SubMenuTableViewCell
        cell.configureCell(menu:Menus.init(menuDict: menuList[indexPath.row]))
        cell.delegate = OrderMenuList()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.15
    }
    
}

class SubMenuTableViewCell: UITableViewCell {
    
    var delegate : MenuAdded?
    var menuImageUrl : String?
    
    lazy var cellImage: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width * 0.4, height: self.frame.height))
        return img
    }()
    
    lazy var title: UILabel = {
        let lb = UILabel.init(frame: CGRect.init(x: self.cellImage.frame.width + 10, y: self.frame.height * 0.1, width: self.frame.width * 0.4, height: self.frame.height * 0.2))
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var desc: UILabel = {
        let yPosition = self.frame.height * 0.4
        let lb = UILabel.init(frame: CGRect.init(x: self.cellImage.frame.width + 10, y: yPosition, width: self.frame.width * 0.4, height: self.frame.height * 0.2))
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.alpha = 0.6
        return lb
    }()
    
    lazy var price: UILabel = {
        let yPosition = self.frame.height * 0.7
        let lb = UILabel.init(frame: CGRect.init(x: self.cellImage.frame.width + 10, y: yPosition, width: self.frame.width * 0.4, height: self.frame.height * 0.2))
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
        self.backgroundColor = .white
        self.selectionStyle = .none
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = .zero
        self.layoutMargins = .zero
        configureCellImage(url: menu.img!)
        self.addSubview(cellImage)
        title.text = menu.title
        self.addSubview(title)
        desc.text = menu.desc
        self.addSubview(desc)
        price.text = ("\(menu.price!) ฿")
        self.addSubview(price)
        self.addSubview(addBtn)
        menuImageUrl = menu.img
    }
    
    func addMenu(){
        delegate?.getMenu(menu: self)
    }
    
    private func configureCellImage(url : String){
        let urlPath = URL(string: url)
        cellImage.kf.setImage(with: urlPath)
    }
}
