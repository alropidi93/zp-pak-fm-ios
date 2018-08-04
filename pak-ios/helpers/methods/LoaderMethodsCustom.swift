//
//  LoaderMethodsCustom.swift
//  pak-ios
//
//  Created by inf227adm on 19/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class LoaderMethodsCustom {

    static func startLoaderCustom( uiViewController: UIViewController) {
        
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        loadingIndicator.startAnimating();
//
//        alert.view.addSubview(loadingIndicator)
//        uiViewController.present(alert, animated: true, completion: nil)
//
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pakAlert = storyboard.instantiateViewController(withIdentifier: "vc_loader_custom") as! PakLoaderAlert
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
       
        uiViewController.present(pakAlert, animated: true, completion: nil)
    }
    
    static func stopLoaderCustom( uiViewController: UIViewController) {
//        DispatchQueue.global().async {
//            DispatchQueue.main.sync {
//                let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "vc_loader_custom") as! PakLoaderAlert
//              pakAlert.stopLoader()
//            }
//        }
//
        let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "vc_loader_custom") as! PakLoaderAlert
        pakAlert.removeFromParentViewController()
    }
    
    
   
    
    
    
}
