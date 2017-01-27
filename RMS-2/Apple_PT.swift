//
//  Apple_PT.swift
//  RMS-2
//
//  Created by Pondz on 1/26/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import Material

class Apple_PT: UIViewController {

    lazy var imageView: UIImageView = {
        let width = self.view.frame.width * 0.4
        let size = CGSize.init(width: width, height: width)
        let origin = CGPoint.init(x: ((self.view.frame.width / 2) - (width / 2)), y: ((self.view.frame.height / 2) - (size.height / 2)))
        let iv = UIImageView.init(frame: CGRect.init(origin: origin , size: size))
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.grey.lighten1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureImageView()
    }
    
    func configureImageView(){
        imageView.setFAIconWithName(icon: FAType.FAApple, textColor: .black)
        self.view.addSubview(imageView)
    }

}
