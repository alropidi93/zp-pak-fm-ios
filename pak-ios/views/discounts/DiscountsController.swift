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

class DiscountsController : UIViewController, NVActivityIndicatorViewable , AlertCodeInvitationDelegate {
    private let reuse_identifier = "cvc_discount_item"
    
    @IBOutlet weak var l_code: UILabel!
    @IBOutlet weak var v_add_code: UIView!
    @IBOutlet weak var v_code_show: UIView!
    @IBOutlet weak var cv_discount_list: UICollectionView!
    @IBOutlet weak var b_add_invitation: UIButton!
    
    private var items : [DiscountDC] = []
    
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
    
    func setElements() {
        self.getListDiscount()
        l_code.text = ConstantsModels.static_user?.codeInvitation
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCAddCode
        cell.l_date_discount.text = self.items[indexPath.item].caducityDate
        cell.l_motive.text = Constants.MOTIVE + self.items[indexPath.item].detail
        cell.l_discount_percent.text = String(self.items[indexPath.item].percentage) + " %"
        return cell
    }
    
    @IBAction func ba_copy(_ sender: Any) {
        UIPasteboard.general.string = ConstantsModels.static_user?.codeInvitation
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
        self.register_code(textFieldValue)
        self.getListDiscount()
    }
    
    func register_code(_ codeInvitation : String) {
        var params : Parameters
        let idUser  :UInt64 = (ConstantsModels.static_user?.idUser)!
        params = [ "IdUsuario": idUser,
                   "CodigoInvitacion": codeInvitation]
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        Alamofire.request(URLs.RegisterInvitationCode, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        self.getListDiscount()
                    }else{
                        AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                    }
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
    
    func showDiscuount() {
        self.v_add_code.isHidden = true
        self.v_code_show.isHidden = false
    }
    
    func getListDiscount() {
        var params : Parameters
        let idUser  :UInt64 = (ConstantsModels.static_user?.idUser)!
        params = [ "IdUsuario": idUser,
        ]
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        Alamofire.request(URLs.ListDiscount, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        if jsonResult["Descuentos"].count > 0 {
                            for ( _ , element) in jsonResult["Descuentos"] {
                                let discount  = DiscountDC(element)
                                self.items.append(discount)
                            }
                            self.showDiscuount()
                        }
                        self.cv_discount_list.reloadData()
                        
                    }else{
                        AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                    }
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
