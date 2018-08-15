//
//  PakAlertRecoverAccount.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/14/18.
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

class PakAlertRecoverAccount: UIViewController  ,NVActivityIndicatorViewable{
    @IBOutlet weak var tf_code_invitation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    @IBAction func b_close(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func b_restartPassword(_ sender: Any) {
        if (self.tf_code_invitation.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El email no puede estar vacío", uiViewController: self)
            return
        } else if (self.tf_code_invitation.text?.count)! > 50 {
            AlarmMethods.errorWarning(message: "El email no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        } else if !isValidEmail(testStr: tf_code_invitation.text!){
            AlarmMethods.errorWarning(message: "No es un correo valido", uiViewController: self)
            return
        }
            self.restartPassword(tf_code_invitation.text!)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func restartPassword(_ email : String){
        let params: Parameters = [ "Email": email ]
        Alamofire.request(URLs.RecoveryPassword, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK" {
                        self.alertDialog(uiViewController: self)

                        self.dismiss(animated: false, completion: nil)


                    } else {
                                         
                        if let jsonResponse = response.result.value {
                            let jsonResult = JSON(jsonResponse)
                            AlarmMethods.ReadyCustom(message: "Tu contraseña ha sido restablecida, pero ocurrió un error al enviarte el correo con la contraseña actualizada. Por favor,contáctate con ventas@pak.pe.", title_message: "¡Listo!", uiViewController: self)

                        } else {
                            AlamoMethods.defaultError(self)
                        }
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
    
   
        func alertDialog(uiViewController: UIViewController) {
            let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "vc_pak_success_pass") as! PakAlertSuccessPass
            pakAlert.definesPresentationContext = true
            pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            uiViewController.present(pakAlert, animated: true, completion: nil)
        }
  
}

