//
//  SideMenuOutLogin.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/14/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//
import Foundation
import SideMenu

class SideMenuOutLogin: UIViewController  {
    let segue_login = "segue_splash_login"
    private let segue_about = "segue_about"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func login(_ sender: Any) {
        self.performSegue(withIdentifier: self.segue_login, sender: self)
    }
    
    @IBAction func initial(_ sender: Any) {
        NotificationCenter.default.post(name: .viewInit, object: nil, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func store(_ sender: Any) {
        NotificationCenter.default.post(name: .viewStore, object: nil, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func aboutPak(_ sender: Any) {
        self.performSegue(withIdentifier: (self.segue_about), sender: self)
    }
}
