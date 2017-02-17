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
    var price : Double? = nil
    var total : Double? = nil
    
    func configureCell(ordDict : Order){
        self.backgroundColor = Color.white
        self.selectionStyle = .none
        self.addSubview(cancelButton)
        price = ordDict.menuPrice!
        configureImageView(url: ordDict.menuImageUrl!)
        configureTitle(title: ordDict.menuTitle!)
        configureStepper(quantity: ordDict.orderQuantity!)
        configureTotalPrice(net : ordDict.calculateNet())
        configureLayout()
        imageUrl = ordDict.menuImageUrl!
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
    
    private func configureTotalPrice(net : Double){
        print(net)
        self.totalPrice.text = "\(net) ฿"
    }
    
    private func configureTitle(title : String){
        self.title.text = title
    }
    
    private func configureImageView(url : String){
        let urlPath = URL(string: url)
        imageViewCell.kf.setImage(with: urlPath)
    }
    
    @IBAction func gmStepperClicked(_ sender: GMStepper) {
        self.total = sender.value * price!
        self.totalPrice.text = "\(total!) ฿"
        if(sender.value <= 1) { return }
        delegate?.stepperClicked(cell : self)
    }
    
    internal func cancelButtonClicked(_ sender : IconButton){
        delegate?.cancelButtonClicked(order : self)
    }
}
