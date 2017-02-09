//
//  OrderListCell.swift
//  RMS-2
//
//  Created by Pondz on 2/9/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material

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
        self.selectionStyle = .none
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
        let urlPath = URL(string: url)
        imageViewCell.kf.setImage(with: urlPath)
    }
    
    @IBAction func stepperClicked(_ sender: UIStepper) {
        quantity.text = "\(Int.init(sender.value))"
        self.total = (Int.init(quantity.text!)! * Int.init(price!))
        self.totalPrice.text = "\(total!) ฿"
        delegate?.stepperClicked(cell : self)
    }
}
