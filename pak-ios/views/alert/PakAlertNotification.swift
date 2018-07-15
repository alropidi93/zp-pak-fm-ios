//
//  PakAlertNotification.swift
//  pak-ios
//
//  Created by italo on 13/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//


import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView

class PakAlertNotification : UIViewController,NVActivityIndicatorViewable {
    var number : Int = 0
    var val : Int = 3
    @IBAction func b_accept(_ sender: Any) {
        self.calification()
    }
    
    func calification() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        let params: Parameters = ["Numero": ConstantsModels.numberBox,
                                  "Calificacion": val]
        Alamofire.request(URLs.CalificationOrder, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let _ = JSON(jsonResponse)
                    ConstantsModels.numberBox = 0
                    self.dismiss(animated: false, completion: nil)

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

