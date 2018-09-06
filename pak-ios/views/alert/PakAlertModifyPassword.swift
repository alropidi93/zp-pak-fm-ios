//
//  PakAlertModifyPassword.swift
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

class PakAlertModifyPassword : UIViewController ,NVActivityIndicatorViewable{
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_newPassword: UITextField!
    @IBOutlet weak var tf_repassword: UITextField!
    
    var pushBack = false
    var vc = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
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
    
    @IBAction func b_modifyPassword(_ sender: Any) {
        print(tf_newPassword.text?.count)
        if (self.tf_password.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "Debes completar todos los campos.", uiViewController: self)
            return
        }else if (self.tf_newPassword.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "Debes completar todos los campos.", uiViewController: self)
            return
        }else if (self.tf_repassword.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "Debes completar todos los campos.", uiViewController: self)
            return
        }else if (self.tf_newPassword.text?.count)! < 6 {
            AlarmMethods.errorWarning(message: "La contraseña debe tener 6 caracteres como minimo.", uiViewController: self)
            return
        }else if( self.tf_newPassword.text! != self.tf_repassword.text!){
            AlarmMethods.errorWarning(message: "Las contraseñas no coinciden.", uiViewController: self)
            return
        }else if (self.tf_password.text! == self.tf_newPassword.text!){
            AlarmMethods.errorWarning(message: "La nueva contraseña debe ser distinta a la contraseña actual.", uiViewController: self)

        }
        
        
        modifyPassword()
    }
    
    func modifyPassword() {
        PakLoader.show() 
        let params: Parameters = [ "Username": ConstantsModels.static_user?.userName as Any, "Password": MD5(self.tf_password.text!) , "NuevoPassword": MD5(self.tf_newPassword.text!), "RepetirPassword": MD5(self.tf_repassword.text!) ,
                                  ]
        Alamofire.request(URLs.PasswordModify, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
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
                        
                        AlarmMethods.ReadyCustomWithPushBack(message: "Tu contraseña ha sido actualizada correctamente", title_message: "¡Listo!", uiViewController: self)
                        

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
                if let jsonResponse = response.result.value {
                    let _ = JSON(jsonResponse)
                   AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)
                }
            }
                             
        }
    }
}
