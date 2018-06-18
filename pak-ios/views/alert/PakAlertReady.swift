//
//  PakAlertReady.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/13/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class PakAlertReady : UIViewController {
    var registerDelegate : PakAlertRegisterDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
  
    @IBAction func b_accept(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        registerDelegate?.okButtonTapped()

    }
    
    
}
