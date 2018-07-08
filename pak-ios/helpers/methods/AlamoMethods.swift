//
//  AlomoMethods.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/25/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AlamoMethods {
    static func getAlamoSessionManager() -> Alamofire.SessionManager {
        return Alamofire.SessionManager()
    }
    
    static func connectionError(uiViewController: UIViewController) {
        self.templateError(title: "Sin respuesta", message: "No se obtuvo datos del servidor. Verifique su conexión de internet. Gracias.", uiViewController: uiViewController)
    }
    
    static func defaultError(_ uiViewController: UIViewController) {
        self.templateError(title: "¡Oops!", message: "Ocurrió un error al realizar la operación. Si el problema persiste, contáctese con ventas@pak.pe", uiViewController: uiViewController)
    }
    
    static func customError(message: String, uiViewController: UIViewController) {
        self.templateError(title: "Alerta", message: message, uiViewController: uiViewController)
    }
    
    private static func templateError(title: String, message: String, uiViewController: UIViewController){
        let alertManager = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let holderView = alertManager.view.subviews.first
        let contentView = holderView?.subviews.first
        for subview in (contentView?.subviews)! {
            subview.backgroundColor = UtilMethods.hexStringToUIColor(hex: Constants.WHITE)
        }
        
        alertManager.setValue(NSAttributedString(string: alertManager.title!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UtilMethods.hexStringToUIColor(hex: Constants.VELVET_ORANGE)]), forKey: "attributedTitle")
        alertManager.setValue(NSAttributedString(string: alertManager.message!, attributes: [NSAttributedStringKey.foregroundColor : UtilMethods.hexStringToUIColor(hex: Constants.VELVET_ORANGE)]), forKey: "attributedMessage")
        
        uiViewController.present(alertManager, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3, execute: {alertManager.dismiss(animated: false, completion: nil)
        })
    }
}

