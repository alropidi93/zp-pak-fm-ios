//
//  MainControllerOut.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/2/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Firebase


class MainControllerOut : UIViewController, NVActivityIndicatorViewable, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeNavigationBarWithSearch()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fullKeyboardSupport()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
