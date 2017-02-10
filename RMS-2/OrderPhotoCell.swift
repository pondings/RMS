//
//  OrderPhotoCell.swift
//  RMS-2
//
//  Created by Pondz on 2/10/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Kingfisher

class OrderPhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(url : String){
        let urlPath = URL(string: url)
        imageView.kf.setImage(with: urlPath)
        self.cornerRadius = 8
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
    }
}
