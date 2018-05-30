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

class DiscountsController : UIViewController , PakAlertCodeInvitationDelegate {

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
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "vc_pak_alert_invitation") as! PakAlertCodeInvitation
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.codeInvitationDelegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
    func okButtonTapped(_ textFieldValue: String) {
        if textFieldValue == PreferencesMethods.getUserFromOptions()?.codeInvitation{
            UpdateAccount()
            showOrHideDiscuount()
        }else {
            let snackbar = TTGSnackbar(message: "No coinciden los codigos", duration: .middle)
            snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
            snackbar.show()
        }
    }
    
    func UpdateAccount(){
        //Veo la cuenta
    }
    
    func showOrHideDiscuount(){
        //veo si que tiene que seguir oculta o si tengo que mostrar la cuenta
    }
   
}
