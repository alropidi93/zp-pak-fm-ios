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
        if tf_code_invitation.text != nil {
            self.restartPassword(tf_code_invitation.text!)
        }
    }
    
    func restartPassword(_ email : String){
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        let params: Parameters = [ "Email": email ]
        Alamofire.request(URLs.RecoveryPassword, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
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
                    AlarmMethods.errorWarning(message: jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
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

