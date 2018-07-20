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
    
    @IBAction func b_modifyPassword(_ sender: Any) {
        modifyPassword()
    }
    
    func modifyPassword() {
        
        let params: Parameters = [ "Username": ConstantsModels.static_user?.userName as Any, "Password": MD5(self.tf_password.text!) , "NuevoPassword": MD5(self.tf_newPassword.text!), "RepetirPassword": MD5(self.tf_repassword.text!) ,
                                   ]
        Alamofire.request(URLs.PasswordModify, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrío un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        //make a pop up sucess
                    } else {
                                        LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
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
                    AlarmMethods.errorWarning(message: jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
                            LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
        }
    }
}
