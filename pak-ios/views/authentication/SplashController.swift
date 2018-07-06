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
    
    private let splash_identifier = "segue_splash_main"
    
    @IBOutlet weak var iv_logo: UIImageView!
    
    var images: [UIImage] = [UIImage(named: "dwb-pak-splash-1")!,UIImage(named: "dwb-pak-splash-2")!,UIImage(named: "dwb-pak-splash-3")!,UIImage(named: "dwb-pak-splash-4")!,UIImage(named: "dwb-pak-splash-5")!]
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        self.iv_logo.animationImages = self.images
        
        self.iv_logo.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loginUser()
        if PreferencesMethods.isFirstTime() {
            PreferencesMethods.saveFirstTime()
        }
        OperationQueue.main.addOperation {
            [weak self] in
            self?.performSegue(withIdentifier: (self?.splash_identifier)!, sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    func getGUID() {
        let params: Parameters = ["GUID": PreferencesMethods.getSmallBoxFromOptions()?.GUID ?? ""]
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    let obtenerCajita = SmallBoxDC(jsonResult)
                    PreferencesMethods.saveSmallBoxToOptions(obtenerCajita)
                    ConstantsModels.CountItem = obtenerCajita.items.count
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
        }
    }
    
    func loginUser() {

        if PreferencesMethods.getSmallBoxFromOptions() == nil {
            getGUID()
            return
        }
        let params: Parameters = [ "IdUsuario": PreferencesMethods.getIdFromOptions() ?? 0,
                                   "AccessToken": PreferencesMethods.getAccessTokenFromOptions() ?? "" ,
                                   "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID,
                                    "FCMToken" : ""
        ]
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
                        ConstantsModels.UserStatic = userDC // aqui se guarda pero staticamente
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
}
