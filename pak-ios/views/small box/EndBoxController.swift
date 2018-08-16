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

class EndBoxController: UIViewController,AlertEndBoxDelegate {
    
    // Segues
    @IBOutlet var iv_logo_end: UIImageView!
    private let splash_identifier = "segue_splash_close"
    private var animation_parts: [UIImage] = [ UIImage(named: "dwb-pak-splash-5")!, UIImage(named: "dwb-pak-splash-4")!, UIImage(named: "dwb-pak-splash-3")!,UIImage(named: "dwb-pak-splash-2")!,UIImage(named: "dwb-pak-splash-1")!]
    var alertEndBoxDelegate : AlertEndBoxDelegate? = nil
    
    //Image Constraints
    @IBOutlet weak var imageHorizontalConstraint: NSLayoutConstraint!
    

    // Common functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        self.imageHorizontalConstraint.constant = UIScreen.main.bounds.width * -1
        self.view.layoutIfNeeded()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doCenterFromLeft()
        /*UIView.animate(withDuration: 1, animations: {
            self.iv_logo_end.frame.origin.x -= 0
        }){_ in
            UIView.animateKeyframes(withDuration: 1, delay: 0.25, options: [], animations: {
                self.iv_logo_end.frame.origin.x -= 400
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
                                
                                self?.alertDialog(uiViewController: self!)
                                
                            })
                        }
                    }
                }
            })
        }*/
    }
    
    private func doCenterFromLeft(){
        UIView.animate(withDuration: 0.8){
            self.imageHorizontalConstraint.constant = 0
            self.view.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.doImageTransition()
            }
        }
    }
    
    var imgCount = 0
    
    private func doImageTransition(){
        self.imgCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            
            switch self.imgCount {
            case 1:
                self.iv_logo_end.image = #imageLiteral(resourceName: "dwb-pak-splash-4")
                self.doImageTransition()
            case 2:
                self.iv_logo_end.image = #imageLiteral(resourceName: "dwb-pak-splash-3")
                self.doImageTransition()
            case 3:
                self.iv_logo_end.image = #imageLiteral(resourceName: "dwb-pak-splash-2")
                self.doImageTransition()
            case 4:
                self.iv_logo_end.image = #imageLiteral(resourceName: "dwb-pak-splash-1")
                self.doImageTransition()
            default:
                self.doCenterToRight()
            }
        }
    }
    
    private func doCenterToRight(){
        UIView.animate(withDuration: 0.8){
            self.imageHorizontalConstraint.constant = UIScreen.main.bounds.width
            self.view.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.alertDialog(uiViewController: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func alertDialog(uiViewController: UIViewController) {
        let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "vc_pak_end_box") as! PakAlertEndBox
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pakAlert.alertEndBoxDelegate = self
        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        uiViewController.present(pakAlert, animated: true, completion: nil)
    }
    func okButtonTapped() {
        self.performSegue(withIdentifier: (self.splash_identifier), sender: self)
    }
    
}
