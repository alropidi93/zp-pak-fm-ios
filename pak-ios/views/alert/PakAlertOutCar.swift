//
//  PakAlertOutCar.swift
//  pak-ios
//
//  Created by Alvaro on 8/1/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import FacebookCore
import FacebookLogin
import SwiftHash
import SideMenu
import GoogleSignIn

class PakAlertOutCar: UIViewController,NVActivityIndicatorViewable  {
    
    var alertBoxCar : AlertBoxCarDelegate? = nil

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
alertBoxCar?.okButtonTapped()

    }
    @IBAction func b_cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
}
