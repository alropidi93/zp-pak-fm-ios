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

class SideMenuInLogin: UIViewController, NVActivityIndicatorViewable {
    private let segue_about = "segue_about"
    private let segue_favorites = "segue_favorites"
    private let segue_discounts = "segue_discounts"
    private let segue_edit = "segue_editar"
    private let segue_order = "segue_order"
    
    @IBOutlet weak var b_name: UIButton!
    
    @IBAction func ba_name(_ sender: Any) {
        self.performSegue(withIdentifier: self.segue_edit, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.b_name.setTitle(ConstantsModels.static_user?.names, for : .normal)
    }
    
    @IBAction func logueOut(_ sender: Any) {
        ConstantsModels.static_user = nil
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
            self.stopAnimating()
        }
    }
}
