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
    private let segue_editFbGo = "segue_editarFbGo"
    private let segue_order = "segue_order"
    
    @IBOutlet weak var b_name: UIButton!
    
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet var b_logeout: UIButton!
    
    @IBOutlet weak var iv_user: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        print(UIScreen.main.bounds)
        print(self.view.frame)
        
        
        
        var yourAttributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont(name: "OpenSans-Light", size: 15),
            NSAttributedStringKey.foregroundColor : UIColor(rgb: 0x222222),
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
        ]
        let attributeString = NSMutableAttributedString(string: "Cerrar sesión",
                                                        attributes: yourAttributes)
        b_logeout.setAttributedTitle(attributeString, for: .normal)

    }
 
    @IBAction func ba_name(_ sender: Any) {
        print(ConstantsModels.static_user?.googleID ?? "noval")
        print(ConstantsModels.static_user?.facebookID ?? "noval")
        if (ConstantsModels.static_user?.googleID != "") || (ConstantsModels.static_user?.facebookID != ""){
            self.performSegue(withIdentifier: self.segue_editFbGo, sender: self)
        }else {
            self.performSegue(withIdentifier: self.segue_edit, sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user : UserDC = ConstantsModels.static_user!
        
        if user.googleID != "" {
            if (GIDSignIn.sharedInstance().currentUser != nil) {
                
                let imageUrl = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 400).absoluteString
                let url  = NSURL(string: imageUrl) as! URL
                let data = NSData(contentsOf: url)                
                self.iv_user.image = UIImage(data: data as! Data)
                
            }
        }else if user.facebookID != "" {
            UtilMethods.setImage(imageview: iv_user, imageurl: "https://graph.facebook.com/v3.0/" + user.facebookID + "/picture?type=normal"  , placeholderurl: "dwb_pak_button_info")
            UtilMethods.roundImage(imageview: iv_user)
        }
        //self.b_name.setTitle(ConstantsModels.static_user?.names, for : .normal)
        self.lbl_name.text = ConstantsModels.static_user?.names
    }
    
   
    @IBAction func logueOut(_ sender: Any) {
       /* ConstantsModels.static_user = nil
        PreferencesMethods.deleteAccessTokenFromOptions()
        self.getGUID()
        */
        dismiss(animated: true, completion: nil)

        NotificationCenter.default.post(name: .viewLogueout, object: nil, userInfo: nil)

        //dismiss(animated: true, completion: nil)
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
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
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
                             
        }
    }
}
