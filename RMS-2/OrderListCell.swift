//
//  OrderListCell.swift
//  RMS-2
//
//  Created by Pondz on 2/9/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material
import SnapKit
import GMStepper
import Font_Awesome_Swift

protocol OrderListCellDelegate {
    func stepperClicked(cell : OrderListCell)
    func cancelButtonClicked(order : OrderListCell)
}

class OrderListCell: UITableViewCell {
    
    @IBOutlet weak var imageViewCell : UIImageView!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var totalPrice : UILabel!
    @IBOutlet weak var stepper: GMStepper!
    
    lazy var cancelButton: IconButton = {
        let ic = IconButton.init(frame: CGRect.init())
        ic.pulseColor = .blue
        ic.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside)
        ic.setFAIcon(icon: .FATimes, forState: .normal)
        ic.setFATitleColor(color: Color.red)
        return ic
    }()
    
    var delegate : OrderListCellDelegate?
    var imageUrl : String? = nil
    var price : Int? = nil
    var total : Int? = nil
    
    func configureCell(ordDict : Menu){
        self.backgroundColor = Color.white
        self.selectionStyle = .none
        self.addSubview(cancelButton)
        price = Int.init(ordDict.price!)
        configureImageView(url: ordDict.img!)
        configureTitle(title: ordDict.title!)
        configureStepper(quantity: Double.init(ordDict.quantity!)!)
        configureTotalPrice()
        configureLayout()
        imageUrl = ordDict.img
    }
    
    private func configureLayout(){
        cancelButton.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.height.width.equalTo(24)
        }
        cancelButton.alpha = 0.5
    }
    
    private func configureStepper(quantity : Double){
        stepper.value = quantity
        stepper.tintColor = .white
    }
    
    private func configureTotalPrice(){
        self.totalPrice.text = "\(Int(price! * Int.init(stepper.value))) ฿"
    }
    
    private func configureTitle(title : String){
        self.title.text = title
    }
    
    private func configureImageView(url : String){
        let urlPath = URL(string: url)
        imageViewCell.kf.setImage(with: urlPath)
    }
    
    @IBAction func gmStepperClicked(_ sender: GMStepper) {
        self.total = (Int.init(sender.value) * Int.init(price!))
        self.totalPrice.text = "\(total!) ฿"
        if(sender.value <= 1) { return }
        delegate?.stepperClicked(cell : self)
    }
    
    internal func cancelButtonClicked(_ sender : IconButton){
        delegate?.cancelButtonClicked(order : self)
    }
}
