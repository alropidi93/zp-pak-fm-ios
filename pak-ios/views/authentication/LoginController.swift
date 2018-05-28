//
//  LoginController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView
import FacebookCore
import FacebookLogin
import SwiftHash
import SideMenu

class LoginController : UIViewController, NVActivityIndicatorViewable{
    let segue_identifier = "segue_login_main"
    let signup_identifier = "segue_login_signup"
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.customizeNavigationBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        if PreferencesMethods.isFirstTime() {
            self.getGUID()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullKeyboardSupport()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func login(_ sender: Any) {
        if (self.tf_password.text?.isEmpty)! {
            AlamoMethods.customError(message: "La contraseña no puede estar vacía", uiViewController: self)
            return
        }
        if (self.tf_email.text?.isEmpty)! {
            AlamoMethods.customError(message: "El email no puede estar vacío", uiViewController: self)
            return
        }
        self.loginUser()
        
    }
    
    func getGUID() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        let params: Parameters = [:]
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    let obtenerCajita = SmallBoxDC(jsonResult)
                    PreferencesMethods.saveSmallBoxToOptions(obtenerCajita)
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["message"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
  
    func loginUser() {
    self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)

        if PreferencesMethods.getSmallBoxFromOptions() == nil {
            getGUID()
            
            return
        }
    

        let params: Parameters = [ "Username": self.tf_email.text!,
                                   "Password": MD5(self.tf_password.text!) ,
                                   "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID ]
        Alamofire.request(URLs.login, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        let userDC : UserDC = UserDC(jsonResult)
                        userDC.valid = true
                        PreferencesMethods.saveUserToOptions(userDC)
                        PreferencesMethods.saveSmallBoxToOptions(userDC.smallBox!)
                        self.stopAnimating()
                        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
                    } else {
                        self.stopAnimating()
                        if let jsonResponse = response.result.value {
                            let jsonResult = JSON(jsonResponse)
                            AlarmMethods.errorWarning(message: jsonResult["Msg"].string!, uiViewController: self)
                        } else {
                            AlamoMethods.defaultError(self)
                        }
                    }
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlamoMethods.customError(message: jsonResult["message"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
    
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let loginManager = LoginManager()

        loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                AlarmMethods.errorWarning(message: "No se puede acceder: \(error.localizedDescription)", uiViewController: self)
            case .cancelled:
                AlarmMethods.errorWarning(message: "Tal vez aun no has instalado facebook para el celular?", uiViewController: self)
            case .success( _, _, let accessToken):
                self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
                let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], accessToken: accessToken, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                request.start { (response, result) in
                    switch result {
                    case .success(let value):
                        let params: Parameters = [
                            "id": "",
                            "name": value.dictionaryValue!["name"] ?? "",
                            "lastname": "",
                            "dni": "",
                            "phone": "",
                            "email": value.dictionaryValue!["email"] ?? "",
                            "imageurl": "https://graph.facebook.com/\(value.dictionaryValue!["id"] ?? -1)/picture?type=large"
                        ]
                        self.stopAnimating()
                        
                        //TODO erase after API connection
                        let jsonObj = JSON(params)
                        let userDC = UserDC(jsonObj)
                        PreferencesMethods.saveUserToOptions(userDC)
                        
                        self.stopAnimating()
                        
//                      self.validateExistingUser(userDC)
                    case .failed(let error):
                        self.stopAnimating()
                        AlarmMethods.errorWarning(message: "No se pudo obtener la información: \(error.localizedDescription)", uiViewController: self)
                    }
                }
            }
        }
    }
    
    
    @IBAction func loginWithGoogle(_ sender: Any) {
    }
    
    
    
    
    @IBAction func signUp(_ sender: Any) {
        self.performSegue(withIdentifier: self.signup_identifier, sender: self)
    }
}
