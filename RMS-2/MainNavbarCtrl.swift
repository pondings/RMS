//
//  MainNavbarCtrl.swift
//  RMS-2
//
//  Created by Pondz on 1/19/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material

class MainNavbarCtrl: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationBar.barTintColor = Color.lightBlue.base
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSelf(_:)), name: Notification.Name("dsNavBar"), object: nil)
    }
    
    func dismissSelf(_ state : Notification){
        let ds = state.object as! Bool
        self.setNavigationBarHidden(ds, animated: true)
    }
}
