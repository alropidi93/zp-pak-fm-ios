//
//  PakAlertEndBox.swift
//  pak-ios
//
//  Created by italo on 31/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class PakAlertEndBox: UIViewController  {
    
    var alertEndBoxDelegate : AlertEndBoxDelegate? = nil

    
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMessage.text = "¡Tu compra ha sido procesada!\nRecuerda que solo tienes \(PreferencesMethods.getMaxTime()) minutos para anular tu compra."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    
    @IBAction func b_accept(_ sender: Any) {
        alertEndBoxDelegate?.okButtonTapped()
    }
    
    
    
}
