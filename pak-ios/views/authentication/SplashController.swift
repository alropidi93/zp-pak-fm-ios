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

class SplashController: UIViewController {
    // Segues
    private let splash_identifier = "segue_splash_main"
    
    // Visual variables
    @IBOutlet weak var iv_logo: UIImageView!
    
    // Local variables
    private var animation_parts: [UIImage] = [ UIImage(named: "dwb-pak-splash-2")!, UIImage(named: "dwb-pak-splash-3")!, UIImage(named: "dwb-pak-splash-4")!, UIImage(named: "dwb-pak-splash-5")!,UIImage(named: "dwb-pak-logo-name")!]
    
    // Common functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.iv_logo.animationImages = self.animation_parts
        self.iv_logo.animationRepeatCount = 1
        self.iv_logo.animationDuration = 3
        self.iv_logo.startAnimating()
        
        self.getGUID()
        
        if PreferencesMethods.isFirstTime() {
            PreferencesMethods.saveFirstTime()
        }
        
        // must be careful that the animation duration and this stuff remains equal
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            OperationQueue.main.addOperation {
                [weak self] in
                while (self?.iv_logo.isAnimating)! {} //we wait until is finished
                self?.performSegue(withIdentifier: (self?.splash_identifier)!, sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginUser() {
       
        
        let params: Parameters = [ "IdUsuario": PreferencesMethods.getIdFromOptions() ?? 0,
                                   "AccessToken": PreferencesMethods.getAccessTokenFromOptions() ?? "" ,
                                   "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID,
                                   "FCMToken" : "" ]
        
        Alamofire.request(URLs.loginAccessToken, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                return
            }
            
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        let userDC : UserDC = UserDC(jsonResult)
                        userDC.valid = true
                        ConstantsModels.static_user = userDC // aqui se guarda pero staticamente
                        
                        PreferencesMethods.saveSmallBoxToOptions(userDC.smallBox!)
                        PreferencesMethods.saveAccessTokenToOptions(userDC.accessToken)
                    } else {
                        self.getGUID()
                    }
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
    
    func getGUID() {
        var params : Parameters
        if PreferencesMethods.getSmallBoxFromOptions() == nil {
            params = [ : ]
        }else{
            params = ["GUID": PreferencesMethods.getSmallBoxFromOptions()?.GUID ?? ""]
        }
        
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                return
            }
            
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    let small_box = SmallBoxDC(jsonResult)
                    PreferencesMethods.saveSmallBoxToOptions(small_box)
                    for element in small_box.items{
                        ConstantsModels.count_item = ConstantsModels.count_item + Int(element.cant)
                    }
                    self.loginUser()
                    print("sadafasfsaf")
                    print(PreferencesMethods.getSmallBoxFromOptions()?.GUID)
                    
                    print(ConstantsModels.count_item)
                print("sadafasfsaasdasdasdasfasfsaff")
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
