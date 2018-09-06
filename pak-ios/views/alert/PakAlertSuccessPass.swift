//
//  PakAlertSuccessPass.swift
//  pak-ios
//
//  Created by inf227al on 9/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class PakAlertSuccessPass : UIViewController {
    
    var vc = UIViewController()
    var pushBack = false
 
    @IBAction func b_accept(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        if pushBack {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    
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
    
}
