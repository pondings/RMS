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
import FBSDKLoginKit

class AuthenicationVC: UIViewController,LoginButtonDelegate {
    
    @IBOutlet weak var dismissBtn: UIButton!
    
    lazy var fbLoginBtn: LoginButton = {
        let size = CGSize.init(width: self.view.frame.width / 2, height: self.view.frame.height * 0.05)
        let origin = CGPoint.init(x: ((self.view.frame.width / 2) - (size.width / 2)), y: ((self.view.frame.height / 2) - (size.height / 2)))
        let fb = LoginButton.init(frame: CGRect.init(origin: origin, size: size), readPermissions: [.publicProfile,.email])
        fb.delegate = self
        return fb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(fbLoginBtn)
        view.backgroundColor = Color.lightBlue.base
        dismissBtn.setFAIcon(icon: .FAChevronDown, forState: .normal)
        dismissBtn.setFATitleColor(color: .white)
    }
    
    public func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        dismissSelf("")
    }
    
    public func loginButtonDidLogOut(_ loginButton: LoginButton) {}
    
    
    
    @IBAction func dismissSelf(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


