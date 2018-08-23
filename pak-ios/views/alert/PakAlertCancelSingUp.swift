//
//  PakAlertCancelSingUp.swift
//  pak-ios
//
//  Created by inf227al on 23/08/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation

import Foundation
import UIKit


class PakAlertCancelSingUp: UIViewController  {
    
    var alertCancelSingup : AlertCancelSingUp? = nil
    
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
    
    @IBAction func b_salir(_ sender: Any) {
        alertCancelSingup?.outPressed()
    }
    
    @IBAction func b_cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
}
