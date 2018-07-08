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
    @IBOutlet weak var b_confirm: UIButton!
    @IBOutlet weak var b_cancel: UIButton!
}
