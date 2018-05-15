//
//  SideMenuInLogin.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/14/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SideMenu

class SideMenuInLogin: UIViewController {
    private let segue_about = "segue_about"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func logueOut(_ sender: Any) {
        UserMethods.logoutUserFromOptions()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func initial(_ sender: Any) {
        print("Initial")
    }
    
    @IBAction func store(_ sender: Any) {
        print("store")
    }
    
    @IBAction func Favorities(_ sender: Any) {
        print("Favorities")
    }
    
    @IBAction func Orders(_ sender: Any) {
        print("Orders")
    }
    
    @IBAction func Discounts(_ sender: Any) {
        print("Discounts")
    }
    
    @IBAction func aboutPak(_ sender: Any) {
        self.performSegue(withIdentifier: (self.segue_about), sender: self)
    }
}
