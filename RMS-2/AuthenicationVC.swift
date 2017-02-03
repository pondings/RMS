//
//  AuthenicationVC.swift
//  RMS-2
//
//  Created by Pondz on 2/3/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import Material
import FacebookLogin

class AuthenicationVC: UIViewController {

    lazy var fbLoginBtn: UIButton = {
        let size = CGSize.init(width: self.view.frame.width / 2, height: self.view.frame.height * 0.05)
        let origin = CGPoint.init(x: ((self.view.frame.width / 2) - (size.width / 2)), y: ((self.view.frame.height / 2) - (size.height / 2)))
        let btn = UIButton.init(frame: CGRect.init(origin: origin, size: size))
        btn.backgroundColor = .white
        btn.setFAIcon(icon: .FAFacebook, forState: .normal)
        btn.setFATitleColor(color: .white)
        btn.addTarget(self, action: #selector(loginWithFB), for: .touchUpInside)
        btn.setFATitleColor(color: Color.lightBlue.base)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(fbLoginBtn)
        view.backgroundColor = Color.lightBlue.base
    }
    
    internal func loginWithFB(){
        let loginManager = LoginManager()
        loginManager.logIn( [.publicProfile,.email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
                self.performSegue(withIdentifier: "MainTabBarCtrl", sender: nil)
            }
        }
    }

}
