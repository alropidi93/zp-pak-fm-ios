//
//  SplashController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import UIKit

class SplashController: UIViewController {
    private let segue_identifier = "segue_splash_login"
    private let logged_identifier = "segue_splash_main"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OperationQueue.main.addOperation {
            [weak self] in
            
            if UserMethods.getUserFromOptions() != nil && UserMethods.getUserFromOptions()?.valid == true {
                self?.performSegue(withIdentifier: (self?.logged_identifier)!, sender: self)
            } else {
                self?.performSegue(withIdentifier: (self?.segue_identifier)!, sender: self)
            }
        }
    }
    //https://stackoverflow.com/questions/41797844/swift-ios-multiple-successive-multiple-animations-with-same-uiview
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
