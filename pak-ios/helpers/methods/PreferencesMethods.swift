//
//  PreferencesMethods.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PreferencesMethods {
    static func getSmallBoxFromOptions() -> SmallBoxDC? {
        let defaults = UserDefaults.standard
        let data = defaults.data(forKey: "smallBoxData")
        if data == nil {
            return nil
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: data!) as? SmallBoxDC
        }
    }
    
    static func saveSmallBoxToOptions(_ smallBoxDC : SmallBoxDC) {
        let encodedEventUser = NSKeyedArchiver.archivedData(withRootObject: smallBoxDC)
        let defaults = UserDefaults.standard
        defaults.set(encodedEventUser, forKey: "smallBoxData")
    }
    
    static func deleteSmallBoxFromOptions() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "smallBoxData")
    }
    
    static func getAccessTokenFromOptions() -> String? {
        let defaults = UserDefaults.standard
        let data = defaults.data(forKey: "accessToken")
        if data == nil {
            return nil
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: data!) as? String
        }
    }
    
    static func saveAccessTokenToOptions(_ accessToken : String) {
        let encodedEventUser = NSKeyedArchiver.archivedData(withRootObject: accessToken)
        let defaults = UserDefaults.standard
        defaults.set(encodedEventUser, forKey: "accessToken")
    }
    
    static func deleteAccessTokenFromOptions() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "accessToken")
        
    }
    
    static func getIdFromOptions() -> UInt64? {
        let defaults = UserDefaults.standard
        let data = defaults.data(forKey: "idUser")
        if data == nil {
            return nil
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: data!) as? UInt64
        }
    }
    
    static func saveIdToOptions(_ id : UInt64) {
        let encodedEventUser = NSKeyedArchiver.archivedData(withRootObject: id)
        let defaults = UserDefaults.standard
        defaults.set(encodedEventUser, forKey: "idUser")
    }
    
    static func deleteIdFromOptions() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "idUser")
    }
    
    static func saveFirstTime() {
        let encodedFirstTime = NSKeyedArchiver.archivedData(withRootObject: true)
        let defaults = UserDefaults.standard
        defaults.set(encodedFirstTime, forKey: "firstTime")
    }
    
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        let data = defaults.data(forKey: "firstTime")
        if data == nil {
            return true
        } else {
            return false
        }
    }
    
    static func setMaxTime(_ num: Int){
        UserDefaults.standard.set(num, forKey: "maxTime")
    }
    
    static func getMaxTime() -> Int {
        return UserDefaults.standard.integer(forKey: "maxTime")
    }
    
    // este es el mismo getGUID del login, note que esto hace que la cajita sincronize con el servidor,
    // lo cual no se estaba haciendo por ejemplo al agregar mas items a este, al menos no se actualiazaba el local
    // este metodo se puede invocar de cualquier viewcontroller
    
    static func updateGUID(vc: UIViewController) {
        print("updateGUID")
        let params: Parameters = [:]
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: vc)
                
                
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    let obtenerCajita = SmallBoxDC(jsonResult)
                    print("Working")
                    PreferencesMethods.saveSmallBoxToOptions(obtenerCajita)
                    print(PreferencesMethods.getSmallBoxFromOptions()?.items.count)
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: vc)
                } else {
                    AlamoMethods.defaultError(vc)
                }
            }
            
        }
    }
    
}

