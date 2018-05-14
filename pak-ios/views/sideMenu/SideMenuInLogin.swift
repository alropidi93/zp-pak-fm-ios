//
//  SideMenuInLogin.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/14/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import Foundation
import SideMenu

class SideMenuInLogin: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func LogueOut(_ sender: Any) {
        UserMethods.logoutUserFromOptions()
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
