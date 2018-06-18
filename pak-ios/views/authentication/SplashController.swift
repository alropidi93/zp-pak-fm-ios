//
//  SplashController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation
import Alamofire
import NVActivityIndicatorView
import FacebookCore
import FacebookLogin
import SwiftHash
import SideMenu

class SplashController: UIViewController {
    
    private let splash_identifier = "segue_splash_main"
    
    @IBOutlet weak var iv_logo: UIImageView!
    
    var images: [UIImage] = [UIImage(named: "dwb-pak-splash-1")!,UIImage(named: "dwb-pak-splash-2")!,UIImage(named: "dwb-pak-splash-3")!,UIImage(named: "dwb-pak-splash-4")!,UIImage(named: "dwb-pak-splash-5")!]
    // dwb-pak-logo dwb-pak-logo-name
//    var animatedImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        self.iv_logo.animationImages = self.images
        
        self.iv_logo.startAnimating()
        
//        self.iv_logo.image = UIImage.animatedImage(with: images, duration: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if PreferencesMethods.isFirstTime() {
            self.getGUID()
            PreferencesMethods.saveFirstTime()
        }
        OperationQueue.main.addOperation {
            [weak self] in
            self?.performSegue(withIdentifier: (self?.splash_identifier)!, sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    func getGUID() {
        let params: Parameters = [:]
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
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
                    AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
        }
    }
}
