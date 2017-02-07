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
    
    private func configureFirebase(){
        firPath.observe(.childAdded, with: { [weak self] snapshot -> Void in
            guard let strongSelf = self else {return}
            strongSelf.orderList.append(snapshot.value as! Dictionary<String,AnyObject>)
            strongSelf.tableView.insertRows(at: [IndexPath.init(row: strongSelf.orderList.count - 1, section: 0)], with: .automatic)
        })
        firPath.observe(.childRemoved, with: { [weak self] snapshot -> Void in
            guard let strongSelf = self else {return}
            let removedOrd = snapshot.value as! Dictionary<String,AnyObject>
            for (index,element) in strongSelf.orderList.enumerated(){
                if(element["ord_name"] as! String == removedOrd["ord_name"] as! String) {
                    strongSelf.orderList.remove(at: index)
                    strongSelf.tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
                    break
                }
            }
        })
        firPath.observe(.childChanged, with: { [weak self] snapshot -> Void in
            guard let strongSelf = self else {return}
            let changedOrd = snapshot.value as! Dictionary<String,AnyObject>
            if(changedOrd["ord_total"] as! Int == 0){ snapshot.ref.removeValue() }
            for (index,element) in strongSelf.orderList.enumerated() {
                if(element["ord_name"] as! String == changedOrd["ord_name"] as! String) {
                    let cell = strongSelf.tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? OrderListCell
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

class OrderListCell: UITableViewCell {
    
    @IBOutlet weak var imageViewCell : UIImageView!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var totalPrice : UILabel!
    @IBOutlet weak var quantity : UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var delegate : OrderListCellDelegate?
    var imageUrl : String? = nil
    var price : Int? = nil
    var total : Int? = nil
    
    func configureCell(ordDict : Menu){
        self.backgroundColor = Color.white
        price = Int.init(ordDict.price!)
        configureImageView(url: ordDict.img!)
        configureTitle(title: ordDict.title!)
        configureQuantity(quantity: ordDict.quantity!)
        configureTotalPrice()
        imageUrl = ordDict.img
        configureStepper()
    }
    
    private func configureStepper(){
        stepper.value = Double.init(quantity.text!)!
        stepper.tintColor = .white
        stepper.setBackgroundImage(UIImage(), for: .normal)
        stepper.backgroundColor = Color.lightBlue.base
    }
    
    private func configureQuantity(quantity : String) {
        self.quantity.text = quantity
    }
    
    private func configureTotalPrice(){
        self.totalPrice.text = "\(Int(price! * Int.init(quantity.text!)!)) ฿"
    }
    
    private func configureTitle(title : String){
        self.title.text = title
    }
    
    private func configureImageView(url : String){
        let urlString = url
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if error != nil {return}
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
            DispatchQueue.main.async {self.imageViewCell.image = UIImage(data: data!)}
        }.resume()
    }
    
    @IBAction func stepperClicked(_ sender: UIStepper) {
        quantity.text = "\(Int.init(sender.value))"
        self.total = (Int.init(quantity.text!)! * Int.init(price!))
        self.totalPrice.text = "\(total!) ฿"
        delegate?.stepperClicked(cell : self)
    }
}
