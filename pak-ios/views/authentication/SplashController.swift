//
//  SplashController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
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
import Firebase

class SplashController: UIViewController {
    // Segues
    private let splash_identifier = "segue_splash_main"
    //@IBOutlet var iv_letter_logo: UIImageView!
    
    // Visual variables
    //@IBOutlet weak var iv_logo: UIImageView!
    

//     Local variables
    /*private var animation_parts: [UIImage] = [ UIImage(named: "dwb-pak-splash-1")!,UIImage(named: "dwb-pak-splash-2")!, UIImage(named: "dwb-pak-splash-3")!, UIImage(named: "dwb-pak-splash-4")!, UIImage(named: "dwb-pak-splash-5")!]*/

//     Common functions
    
    
    //new animation variables
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var ivBox: UIImageView!
    @IBOutlet weak var ivText: UIImageView!
    
    @IBOutlet weak var horizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    
    
    var isAnimationDone = false
    var isGUIDLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getGUID()
    }
    
    private func doSlideUp(){
        print("Splash Begin")
        UIView.animate(withDuration: 0.5){
            self.verticalConstraint.constant = 0
            self.horizontalConstraint.constant = 22
            self.view.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.doImageTransition()
            }
        }
    }
    
    var imgCount = 0
    
    private func doImageTransition(){
        self.imgCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            switch self.imgCount {
            case 1:
                self.ivBox.image = #imageLiteral(resourceName: "dwb-pak-splash-2")
                self.doImageTransition()
            case 2:
                self.ivBox.image = #imageLiteral(resourceName: "dwb-pak-splash-3")
                self.doImageTransition()
            case 3:
                self.ivBox.image = #imageLiteral(resourceName: "dwb-pak-splash-4")
                self.doImageTransition()
            case 4:
                self.ivBox.image = #imageLiteral(resourceName: "dwb-pak-splash-5")
                self.doImageTransition()
            default:
                self.doSlideLeft()
            }
        }
    }
    
    private func doSlideLeft(){
        UIView.animate(withDuration: 0.25){
            self.ivText.alpha = 1
            self.horizontalConstraint.constant = 0
            self.view.layoutIfNeeded()
            print("Splash Done")
            self.isAnimationDone = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.isAnimationDone && self.isGUIDLoaded {
                    self.performSegue(withIdentifier: self.splash_identifier, sender: self)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.verticalConstraint.constant = UIScreen.main.bounds.height / 2
        self.view.layoutIfNeeded()
        doSlideUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func animate (imageView : UIImageView , images : [UIImage]){
        
    }
    func loginUser() {
       
        print("Login User")
        
        let params: Parameters = [ "IdUsuario": PreferencesMethods.getIdFromOptions() ?? 0,
                                   "AccessToken": PreferencesMethods.getAccessTokenFromOptions() ?? "" ,
                                   "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID,
                                   "FCMToken" : InstanceID.instanceID().token() ?? "No token" ]
        
        Alamofire.request(URLs.loginAccessToken, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            
            print("AMD 1")
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                return
            }
            
            print("AMD 2")
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        print("AMD 3")
                        let userDC : UserDC = UserDC(jsonResult)
                        userDC.valid = true
                        ConstantsModels.static_user = userDC // aqui se guarda pero staticamente
                        
                        PreferencesMethods.saveSmallBoxToOptions(userDC.smallBox!)
                        PreferencesMethods.saveAccessTokenToOptions(userDC.accessToken)
                        
                    }
                    
                    self.isGUIDLoaded = true
                    if self.isAnimationDone && self.isGUIDLoaded {
                        self.performSegue(withIdentifier: self.splash_identifier, sender: self)
                    }
                    
                    print("AMD 4")
                }
            } else {
                
                print("AMD 5")
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message: jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
        }
    }
    
    func getGUID() {
        print("Get GUID")
        var params : Parameters
        if PreferencesMethods.getSmallBoxFromOptions() == nil {
            params = [ : ]
        }else{
            params = ["GUID": PreferencesMethods.getSmallBoxFromOptions()?.GUID ?? ""]
        }

        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                return
            }

            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    let small_box = SmallBoxDC(jsonResult)
                    PreferencesMethods.saveSmallBoxToOptions(small_box)
                    
                    self.loginUser()
                 
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message: jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
        }
    }
    
}
