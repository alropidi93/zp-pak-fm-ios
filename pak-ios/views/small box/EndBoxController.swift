//
//  EndBoxController.swift
//  pak-ios
//
//  Created by inf227al on 10/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//
import UIKit
import SwiftyJSON
import Foundation
import Alamofire
import NVActivityIndicatorView
import FacebookCore
import FacebookLogin
import SwiftHash
import SideMenu

class EndBoxController: UIViewController {
    // Segues
    @IBOutlet var iv_logo_end: UIImageView!
    private let splash_identifier = "segue_splash_close"
    private var animation_parts: [UIImage] = [ UIImage(named: "dwb-pak-logo-name")!  , UIImage(named: "dwb-pak-splash-4")!, UIImage(named: "dwb-pak-splash-3")!,UIImage(named: "dwb-pak-splash-2")!,UIImage(named: "dwb-pak-splash-1")!]
    
    // Common functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.iv_logo_end.animationImages = self.animation_parts
        self.iv_logo_end.animationRepeatCount = 1
        self.iv_logo_end.animationDuration = 3
        self.iv_logo_end.startAnimating()
        
        if PreferencesMethods.isFirstTime() {
            PreferencesMethods.saveFirstTime()
        }
        
        // must be careful that the animation duration and this stuff remains equal
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            OperationQueue.main.addOperation {
                [weak self] in
                while (self?.iv_logo_end.isAnimating)! {} //we wait until is finished
                self?.performSegue(withIdentifier: (self?.splash_identifier)!, sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}
