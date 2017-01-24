//
//  MainMostView.swift
//  RMS-2
//
//  Created by Pondz on 1/21/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit

class MainMostView: UICollectionViewController {
    internal func didSearch(text: String) {
        print("2")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("navTitle"), object: "Most View")
    }

}
