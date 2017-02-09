//
//  OrderList.swift
//  RMS-2
//
//  Created by Pondz on 1/30/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Material

protocol OrderListCellDelegate {
    func stepperClicked(cell : OrderListCell)
}

class OrderList: UITableViewController,OrderListCellDelegate {

    private var ref : FIRDatabaseReference!
    private var orderList : [Dictionary<String,AnyObject>]! = []
    
    lazy var firPath: FIRDatabaseReference = {
        self.ref = FIRDatabase.database().reference().child("Order").child("first").child("qr001")
        return self.ref
    }()
    
    lazy var emptyView: DataManagent = {
        let size = CGSize.init(width: self.view.frame.width, height: self.view.frame.height)
        let origin = CGPoint.init(x: 0, y: 0)
        let vw = DataManagent.init(frame: CGRect.init(origin: origin, size: size))
        return vw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        configureFirebase()
    }
    
    func customize(){
        tableView.backgroundColor = Color.grey.lighten1
        tableView.contentInset.top = 8
        tableView.contentInset.bottom = 28
        tableView.tableFooterView = UIView()
        self.view.backgroundColor = Color.grey.lighten1
    }
    
    func configureFirebase(){
        firPath.observe(.childAdded, with: { [weak self] snapshot -> Void in
            guard let strongSelf = self else {return}
            let addedValue = snapshot.value as! Dictionary<String,AnyObject>
            strongSelf.orderList.append(addedValue)
            strongSelf.tableView.insertRows(at: [IndexPath.init(row: strongSelf.orderList.count - 1, section: 0)], with: UITableViewRowAnimation.left)
        })
        firPath.observe(.childRemoved, with: { [weak self] snapshot -> Void in
            guard let strongSelf = self else {return}
            let removedOrd = snapshot.value as! Dictionary<String,AnyObject>
            for (index,element) in strongSelf.orderList.enumerated(){
                if(element["ord_name"] as! String == removedOrd["ord_name"] as! String) {
                    strongSelf.orderList.remove(at: index)
                    strongSelf.tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: UITableViewRowAnimation.left)
                    break
                }
            }
        })
        firPath.observe(.childChanged, with: { [weak self] snapshot -> Void in
            guard let strongSelf = self else {return}
            let changedOrd = snapshot.value as! Dictionary<String,AnyObject>
            let changeOrder = Menus.init(ordDict: changedOrd)
            if(Int.init(changeOrder.quantity!) == 0){ snapshot.ref.removeValue() }
            for (index,element) in strongSelf.orderList.enumerated() {
                let elementDict = Menus.init(ordDict: element)
                if(elementDict.title! == changeOrder.title!) {
                    let indexPath = IndexPath.init(row: index, section: 0)
                    let cell = strongSelf.tableView.cellForRow(at: indexPath) as? OrderListCell
                    strongSelf.orderList[index] = changedOrd
                    cell?.configureCell(ordDict: Menus.init(ordDict: changedOrd))
                    break
                }
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrderListCell
        let ordDict = orderList[indexPath.row]
        cell.configureCell(ordDict: Menus.init(ordDict: ordDict))
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 6
    }
    
    func removeAllContent(){
        orderList.removeAll()
        tableView.reloadData()
    }

    func stepperClicked(cell: OrderListCell) {
        var addValue = [String:AnyObject]()
        addValue["ord_name"] = cell.title.text as AnyObject?
        addValue["ord_img"] = cell.imageUrl as AnyObject?
        addValue["ord_total"] = 1 as AnyObject?
        addValue["ord_totalPrice"] = cell.price! as AnyObject?
        addValue["ord_price"] = cell.price! as AnyObject?
        let menuTitle = addValue["ord_name"] as! String
        ref = FIRDatabase.database().reference()
        let refAdd = ref.child("Order").child("first").child("qr001").child(menuTitle)
        refAdd.observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            if (snapshot.value as? Dictionary<String,AnyObject>) != nil {
                addValue["ord_total"] = Int.init(cell.quantity.text!) as AnyObject
                addValue["ord_totalPrice"] = cell.total as AnyObject
            }
            refAdd.setValue(addValue)
        })
    }
}
