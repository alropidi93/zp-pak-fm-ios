//
//  AlertViewPayment.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/6/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//


import Foundation
import UIKit

class AlertViewPayment : UIViewController {
    
    var page : Int = 3
    @IBOutlet weak var uv_pv_payments: UIView!
    
    @IBAction func b_next(_ sender: Any) {
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
