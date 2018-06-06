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
    
    var images: [UIImage] = [UIImage(named: "dwb_pak_menu_button")!, UIImage(named: "dwb_pak_logo")!, UIImage(named: "dwb_pak_menu_button")!, UIImage(named: "dwb_pak_logo")!, UIImage(named: "dwb_pak_menu_button")!, UIImage(named: "dwb_pak_logo")!, UIImage(named: "dwb_pak_menu_button")!, UIImage(named: "dwb_pak_logo")!]
    
    var animatedImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animatedImage = UIImage.animatedImage(with: images, duration: 10.0)
        self.iv_logo.image = self.animatedImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PreferencesMethods.isFirstTime() {
            self.getGUID()
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
