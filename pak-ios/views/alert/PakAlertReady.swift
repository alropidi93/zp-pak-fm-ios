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
    var registerDelegate : AlertRegisterDelegate? = nil
    public var msg: String = ""
    @IBOutlet weak var message: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.message.text = msg
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

