//
//  SideMenuInLogin.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/14/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import FacebookCore
import FacebookLogin
import SwiftHash
import SideMenu
import GoogleSignIn


class SideMenuInLogin: UIViewController, NVActivityIndicatorViewable {
    private let segue_about = "segue_about"
    private let segue_favorites = "segue_favorites"
    private let segue_discounts = "segue_discounts"
    private let segue_edit = "segue_editar"
    private let segue_order = "segue_order"
    
    @IBOutlet weak var b_name: UIButton!
    
    @IBOutlet weak var iv_user: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    @IBAction func ba_name(_ sender: Any) {
        self.performSegue(withIdentifier: self.segue_edit, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user : UserDC = ConstantsModels.static_user!
        
        if user.googleID != "" {
           

            UtilMethods.setImage(imageview: iv_user, imageurl: "" , placeholderurl: "dwb_pak_button_info")
        }else if user.facebookID != "" {
            UtilMethods.setImage(imageview: iv_user, imageurl: "https://graph.facebook.com/v3.0/" + user.facebookID + "/picture?type=normal"  , placeholderurl: "dwb_pak_button_info")
        }
        self.b_name.setTitle(ConstantsModels.static_user?.names, for : .normal)
        
    }
    
    @IBAction func logueOut(_ sender: Any) {
        ConstantsModels.static_user = nil
        PreferencesMethods.deleteAccessTokenFromOptions()
        self.getGUID()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func initial(_ sender: Any) {
        NotificationCenter.default.post(name: .viewInit, object: nil, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func store(_ sender: Any) {
        NotificationCenter.default.post(name: .viewStore, object: nil, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Favorities(_ sender: Any) {
        print("Favorities")
        self.performSegue(withIdentifier: (self.segue_favorites), sender: self)
    }
    
    @IBAction func Orders(_ sender: Any) {
        self.performSegue(withIdentifier: (self.segue_order), sender: self)
    }
    
    @IBAction func Discounts(_ sender: Any) {
        self.performSegue(withIdentifier: (self.segue_discounts), sender: self)
    }
    
    @IBAction func aboutPak(_ sender: Any) {
        self.performSegue(withIdentifier: (self.segue_about), sender: self)
    }
    
    func getGUID() {
        
        let params: Parameters = [:]
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrío un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    let obtenerCajita = SmallBoxDC(jsonResult)
                    print(obtenerCajita.GUID)
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
                            LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
        }
    }
}
