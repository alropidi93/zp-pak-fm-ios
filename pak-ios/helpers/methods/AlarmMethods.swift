//
//  AlarmMethods.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/25/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class AlarmMethods {
   
    static func errorWarning(message: String, uiViewController: UIViewController) {
        let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "vc_pak_alert") as! PakAlert
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pakAlert.message = message
        uiViewController.present(pakAlert, animated: true, completion: nil)
    }
    
    
    static func ReadyCustom(message: String ,title_message : String, uiViewController: UIViewController) {
        let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "vc_pak_custom_ready") as! PakAlertCustomReady
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pakAlert.message = message
        pakAlert.title_message = title_message
        uiViewController.present(pakAlert, animated: true, completion: nil)
    }
    
    static func finishWarning(title: String, message: String, handler: (()->())?, uiViewController: UIViewController) {
        let alertManager = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in handler!() })
        alertManager.addAction(okAction)
        let holderView = alertManager.view.subviews.first
        let contentView = holderView?.subviews.first
        for subview in (contentView?.subviews)! { subview.backgroundColor = UIColor.white }
        alertManager.setValue(NSAttributedString(string: alertManager.title!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UtilMethods.hexStringToUIColor(hex: Constants.VELVET_ORANGE)]), forKey: "attributedTitle")
        alertManager.setValue(NSAttributedString(string: alertManager.message!, attributes: [NSAttributedStringKey.foregroundColor : UtilMethods.hexStringToUIColor(hex: Constants.VELVET_ORANGE)]), forKey: "attributedMessage")
        alertManager.view.tintColor = UtilMethods.hexStringToUIColor(hex: Constants.VELVET_ORANGE)
        uiViewController.present(alertManager, animated: true, completion: nil)
    }
    
    
}
