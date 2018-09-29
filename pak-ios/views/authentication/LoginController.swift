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
import FirebaseMessaging
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
            NSAttributedStringKey.foregroundColor : UIColor(rgb: 0x222222),
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributeString = NSMutableAttributedString(string: "Olvidé mi contraseña",
                                                        attributes: yourAttributes)
        b_forgot_password.setAttributedTitle(attributeString, for: .normal)
        

        tf_email.attributedPlaceholder = NSAttributedString(string: "Usuario / Email",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor(rgb: 0x6D6D6D)])
        tf_password.attributedPlaceholder = NSAttributedString(string: "Contraseña",
                                                            attributes: [NSAttributedStringKey.foregroundColor: UIColor(rgb: 0x6D6D6D)])
        
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

        let params: Parameters = [:]
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
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
                             
        }
    }

    func loginUser() {
        //self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        PakLoader.show()

        if PreferencesMethods.getSmallBoxFromOptions() == nil {
            getGUID()
            return
        }
        
        //amd token patch
        print("AMD: Login Token: \(Messaging.messaging().fcmToken)")
        
        let params: Parameters = [ "Username": self.tf_email.text!,
                                   "Password": MD5(self.tf_password.text!) ,
                                   "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID,
                                   "FCMToken" : Messaging.messaging().fcmToken ?? "No token"
        ]
        
        /*let params: Parameters = [ "Username": self.tf_email.text!,
                                   "Password": MD5(self.tf_password.text!) ,
                                   "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID,
                                   "FCMToken" : InstanceID.instanceID().token() ?? "No token"
                                   ]*/
        Alamofire.request(URLs.login, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            PakLoader.hide()
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
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

//                         
                        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
                    } else {
                                         
                        if let jsonResponse = response.result.value {
                            let jsonResult = JSON(jsonResponse)
                            AlarmMethods.errorWarning(message: jsonResult["Msg"].string!, uiViewController: self)
                        } else {
                            AlamoMethods.defaultError(self)
                        }
                    }
                }
            } else {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)
            }
                             
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
                let request = GraphRequest(graphPath: "me", parameters: ["fields":"id,email,first_name,last_name,birthday"], accessToken: accessToken, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                request.start { (response, result) in
                    switch result {
                    case .success(let value):
                        self.stopAnimating()
                        let userDC : UserDC = UserDC()
                        userDC.names = value.dictionaryValue!["first_name"] as! String
                        userDC.lastNames = value.dictionaryValue!["last_name"] as! String
                        userDC.userName = value.dictionaryValue!["email"] as! String

                        userDC.facebookID = value.dictionaryValue!["id"] as! String
//
                        print(FBSDKAccessToken.current().tokenString)
                        self.validateFacebook(userDC)
                        loginManager.logOut()
                    case .failed(let error):
                                         
                        AlarmMethods.errorWarning(message: "No se pudo obtener la información: \(error.localizedDescription)", uiViewController: self)
                    }
                }
            }
        }
    }
    func validateFacebook(_ userDC : UserDC){

        PakLoader.show()
        let params: Parameters = [ "AccessToken": FBSDKAccessToken.current().tokenString,
                                    "FCMToken": Messaging.messaging().fcmToken ?? "No token",
            "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID
        ]
        Alamofire.request(URLs.LoginFb, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            PakLoader.hide()    
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
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

                                         
                        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
                    } else {
                                         
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
                             
        }
    }

    @IBAction func loginWithGoogle(_ sender: Any) {
                GIDSignIn.sharedInstance().signOut()
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
                         
    }

    func validateGoogle (_ userDC : UserDC, _ tokenvalue : String){
        PakLoader.show()
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)


        let params: Parameters = [ "AccessToken": tokenvalue,
                                   "FCMToken": Messaging.messaging().fcmToken ?? "no token",
                                   "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID
        ]
        Alamofire.request(URLs.LoginGo, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            PakLoader.hide()
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
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

                                         
                        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
                    } else {
                                         
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
            var DestViewController = segue.destination as! UINavigationController
            if let vc = DestViewController.topViewController as? SignUpGoFbController {
                vc.user = self.user
            }
        }
    }
    
    
    //device orientation override
    override var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
            print("iPad & Landscape")
            return UITraitCollection(
                traitsFrom: [UITraitCollection(horizontalSizeClass: .regular),//este es el que sirve? (no se la verdad .-.)
                    UITraitCollection(verticalSizeClass: .regular)]
            )
        }else if UIDevice.current.userInterfaceIdiom == .phone && UIDevice.current.orientation.isPortrait {
            print("iPhone & Portrait")
            return UITraitCollection(
                traitsFrom: [UITraitCollection(horizontalSizeClass: .compact),//este es el que sirve (creo ._. )
                    UITraitCollection(verticalSizeClass: .compact)]
            )
        }
        return super.traitCollection
    }
}
