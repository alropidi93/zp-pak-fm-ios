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
import FBSDKCoreKit
import SwiftHash
import SideMenu
import GoogleSignIn
import Firebase
class LoginController : UIViewController, NVActivityIndicatorViewable,GIDSignInDelegate, GIDSignInUIDelegate{
    
    
    let segue_identifier = "segue_login_main"
    let signup_identifier = "segue_login_signup"
    let signup_identifier_go_fb = "segue_login_signup_fb_go"
    var user : UserDC? = nil
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var b_forgot_password: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.customizeNavigationBar()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        var yourAttributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont(name: "OpenSans-Light", size: 15),
            NSAttributedStringKey.foregroundColor : UIColor(rgb: 0xEAEAEA),//EAEAEA
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributeString = NSMutableAttributedString(string: "Olvidé mi contraseña",
                                                        attributes: yourAttributes)
        b_forgot_password.setAttributedTitle(attributeString, for: .normal)
        
        fullKeyboardSupport()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func login(_ sender: Any) {
        if (self.tf_password.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "La contraseña no puede estar vacía", uiViewController: self)
            return
        }
        if (self.tf_email.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El email no puede estar vacío", uiViewController: self)
            return
        }
        self.loginUser()
        
    }
    
    func getGUID() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        let params: Parameters = [:]
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

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
                    AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
  
    func loginUser() {
//        LoaderMethodsCustom.startLoaderCustom(uiViewController: self)

                self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)

        if PreferencesMethods.getSmallBoxFromOptions() == nil {
            getGUID()
            return
        }
        let params: Parameters = [ "Username": self.tf_email.text!,
                                   "Password": MD5(self.tf_password.text!) ,
                                   "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID,
                                   "FCMToken" : InstanceID.instanceID().token() ?? "No token"
                                   ]
        Alamofire.request(URLs.login, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

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
                        ConstantsModels.static_user = userDC
                        PreferencesMethods.saveSmallBoxToOptions(userDC.smallBox!)
                        PreferencesMethods.saveAccessTokenToOptions(userDC.accessToken)
                        PreferencesMethods.saveIdToOptions(userDC.idUser)
                      
//                        LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
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
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)
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
                let request = GraphRequest(graphPath: "me", parameters: ["fields":"id,email,first_name,last_name,birthday"], accessToken: accessToken, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                request.start { (response, result) in
                    switch result {
                    case .success(let value):
                        self.stopAnimating()
                        let userDC : UserDC = UserDC()
                        userDC.names = value.dictionaryValue!["first_name"] as! String
                        userDC.lastNames = value.dictionaryValue!["last_name"] as! String
                        userDC.userName = value.dictionaryValue!["email"] as! String
                        //"photo_url": user.profile.imageURL(withDimension: 100) ?? "",
                        //print(value.dictionaryValue!["birthday"])
                        //userDC.birthDate = UtilMethods.dateSplit(value.dictionaryValue!["birthday"] as! String)
                        userDC.facebookID = value.dictionaryValue!["id"] as! String
//                        userDC.facebookID = FBSDKAccessToken.current().tokenString
                        print(FBSDKAccessToken.current().tokenString)
                        self.validateFacebook(userDC)
                        loginManager.logOut()
                    case .failed(let error):
                        self.stopAnimating()
                        AlarmMethods.errorWarning(message: "No se pudo obtener la información: \(error.localizedDescription)", uiViewController: self)
                    }
                }
            }
        }
    }
    func validateFacebook(_ userDC : UserDC){
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        
        let params: Parameters = [ "AccessToken": FBSDKAccessToken.current().tokenString,
                                    "FCMToken": InstanceID.instanceID().token() ?? "No token",
            "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID
        ]
        Alamofire.request(URLs.LoginFb, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode

            let data = try! JSONSerialization.data(withJSONObject: response.result.value, options: .prettyPrinted)
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print(string)
            
            
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        let data = try! JSONSerialization.data(withJSONObject: jsonResponse, options: .prettyPrinted)
                        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        print(string ?? "")
                        
                        let userDC : UserDC = UserDC(jsonResult)
                        userDC.valid = true
                        ConstantsModels.static_user = userDC
                        PreferencesMethods.saveSmallBoxToOptions(userDC.smallBox!)
                        PreferencesMethods.saveAccessTokenToOptions(userDC.accessToken)
                        PreferencesMethods.saveIdToOptions(userDC.idUser)
                        
                        self.stopAnimating()
                        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
                    } else {
                        self.stopAnimating()
                        self.user = userDC
                        self.performSegue(withIdentifier: self.signup_identifier_go_fb, sender: self)
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
            self.stopAnimating()
        }
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
                GIDSignIn.sharedInstance().signOut()
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().signIn()
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let userDC : UserDC = UserDC()
            userDC.names = user.profile.givenName
            userDC.lastNames = user.profile.familyName
            userDC.userName = user.profile.email
//            "photo_url": user.profile.imageURL(withDimension: 100) ?? "",
            userDC.googleID = user.userID
            let token : String = user.authentication.idToken
            //InstanceID.instanceID().token() ?? "No token"
            validateGoogle(userDC , token)
        } else {
            print("\(error.localizedDescription)")
        }
        self.stopAnimating()
    }
    
    func validateGoogle (_ userDC : UserDC, _ tokenvalue : String){
        
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)

        
        let params: Parameters = [ "AccessToken": tokenvalue,
                                   "FCMToken": InstanceID.instanceID().token() ?? "no token",
                                   "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID
        ]
        Alamofire.request(URLs.LoginGo, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                self.stopAnimating()
                return
            }
            
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        let data = try! JSONSerialization.data(withJSONObject: jsonResponse, options: .prettyPrinted)
                        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        print(string ?? "")

                        let userDC : UserDC = UserDC(jsonResult)
                        userDC.valid = true
                        ConstantsModels.static_user = userDC
                        PreferencesMethods.saveSmallBoxToOptions(userDC.smallBox!)
                        PreferencesMethods.saveAccessTokenToOptions(userDC.accessToken)
                        PreferencesMethods.saveIdToOptions(userDC.idUser)
                        
                        self.stopAnimating()
                        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
                    } else {
                        self.stopAnimating()
                        self.user = userDC
                        self.performSegue(withIdentifier: self.signup_identifier_go_fb, sender: self)
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
            self.stopAnimating()
        }
    }
    
    
    @IBAction func ForgetMyPassword(_ sender: Any) {
        alertDialog(uiViewController: self)
    }
    func alertDialog(uiViewController: UIViewController) {
        let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "vc_pak_alert_recovery") as! PakAlertRecoverAccount
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext

        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        uiViewController.present(pakAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        self.performSegue(withIdentifier: self.signup_identifier, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.signup_identifier_go_fb {
            if let vc = segue.destination as? SignUpGoFbController {
                vc.user = self.user
            }
        }
    }
}

