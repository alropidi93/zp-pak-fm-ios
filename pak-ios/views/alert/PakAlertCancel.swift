//
//  PakAlertCancel.swift
//  pak-ios
//
//  Created by Paolo Rossi on 7/3/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation

import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView
import FacebookCore
import FacebookLogin
import SwiftHash
import SideMenu

class PakAlertCancel: UIViewController  ,NVActivityIndicatorViewable{

    
    var alertCancel : AlertCancelDelegate? = nil

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
        alertCancel?.okButtonTapped()
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func b_cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
