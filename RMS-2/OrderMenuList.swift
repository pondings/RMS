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

