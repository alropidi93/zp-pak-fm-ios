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

class LoginController : UIViewController, NVActivityIndicatorViewable{
    let segue_identifier = "segue_login_main"
    let singnup_identifier = "segue_login_signup"
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullKeyboardSupport()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(_ sender: Any) {
        if (self.tf_password.text?.isEmpty)! {
            print("hello")
  //          AlarmMethods.errorWarning(message: "La contraseña no puede estar vacía", uiViewController: self)
            return
        }
        
        if (self.tf_email.text?.isEmpty)! {
//            AlarmMethods.errorWarning(message: "El email no puede estar vacío", uiViewController: self)
            print("hello")

            return
        }
        let params: Parameters = [ "email": self.tf_email.text!, "password": self.tf_password.text! , "GUID": ""]

        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        
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
                    let userDC = UserDC(jsonResult["body"])
                    userDC.valid = true
                    UserMethods.saveUserToOptions(userDC)
                    self.performSegue(withIdentifier: self.segue_identifier, sender: self)
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

    
    
    @IBAction func signUp(_ sender: Any) {
    }
}
