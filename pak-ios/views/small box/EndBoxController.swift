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
    private var animation_parts: [UIImage] = [ UIImage(named: "dwb-pak-splash-5")!, UIImage(named: "dwb-pak-splash-4")!, UIImage(named: "dwb-pak-splash-3")!,UIImage(named: "dwb-pak-splash-2")!,UIImage(named: "dwb-pak-splash-1")!]
    
    // Common functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animate(withDuration: 1, animations: {
            self.iv_logo_end.frame.origin.x += 200
        }){_ in
            UIView.animateKeyframes(withDuration: 1, delay: 0.25, options: [], animations: {
                self.iv_logo_end.frame.origin.x -= 0
            },completion: {(finished: Bool) in
                
                self.iv_logo_end.image = self.animation_parts.last
                self.iv_logo_end.animationImages = self.animation_parts
                self.iv_logo_end.animationRepeatCount = 1
                self.iv_logo_end.animationDuration = 1.0
                self.iv_logo_end.startAnimating()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    OperationQueue.main.addOperation {
                        [weak self] in
                        while (self?.iv_logo_end.isAnimating)! {
                        }
                        UIView.animate(withDuration: 0.75, animations: {
                            self?.iv_logo_end.frame.origin.x -= 0
                        }){_ in
                            UIView.animateKeyframes(withDuration: 0.75, delay: 0.25, options: [], animations: {
                                
                                self?.iv_logo_end.frame.origin.x += 400
                            },completion: {(finished: Bool) in
                                self?.performSegue(withIdentifier: (self?.splash_identifier)!, sender: self)
                            })
                        }
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}
