//
//  DiscountsController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/28/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftHash
import SideMenu
import TTGSnackbar
class DiscountsController : UIViewController{

    @IBOutlet weak var l_code: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setElements(){
        
        l_code.text = PreferencesMethods.getUserFromOptions()?.codeInvitation
    }
    
    @IBAction func ba_copy(_ sender: Any) {
        UIPasteboard.general.string = PreferencesMethods.getUserFromOptions()?.codeInvitation
        let snackbar = TTGSnackbar(message: "Codigo copiado a portapales", duration: .middle)
        snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
        snackbar.show()
    }
    
    
    @IBAction func ba_add_invitation(_ sender: Any) {
        let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "vc_pak_alert_invitation") as! PakAlert
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pakAlert.message = message
        uiViewController.present(pakAlert, animated: true, completion: nil)
    }
}
