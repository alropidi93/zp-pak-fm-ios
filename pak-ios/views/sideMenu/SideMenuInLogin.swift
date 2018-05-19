//
//  SideMenuInLogin.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/14/18.
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


class SideMenuInLogin: UIViewController, NVActivityIndicatorViewable {
    private let segue_about = "segue_about"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func logueOut(_ sender: Any) {
        PreferencesMethods.logoutUserFromOptions()
        PreferencesMethods.deleteSmallBoxFromOptions()
        getGUID()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func initial(_ sender: Any) {
        print("Initial")
    }
    
    @IBAction func store(_ sender: Any) {
        print("store")
    }
    
    @IBAction func Favorities(_ sender: Any) {
        print("Favorities")
    }
    
    @IBAction func Orders(_ sender: Any) {
        print("Orders")
    }
    
    @IBAction func Discounts(_ sender: Any) {
        print("Discounts")
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
                    PreferencesMethods.saveSmallBoxToOptions(obtenerCajita)
                    
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["message"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
        }
        self.stopAnimating()
    }
}
