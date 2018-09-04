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

class DiscountsController : UIViewController, NVActivityIndicatorViewable , AlertCodeInvitationDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    private let reuse_identifier = "cvc_discount_item"
    
    @IBOutlet weak var l_code: UILabel!
    @IBOutlet weak var v_add_code: UIView!
    @IBOutlet weak var v_code_show: UIView!
    @IBOutlet weak var cv_discount_list: UICollectionView!
    @IBOutlet weak var b_add_invitation: UIButton!
    
    private var items : [DiscountDC] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeNavigationBarDiscount()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.cv_discount_list.delegate = self
        self.cv_discount_list.dataSource = self
        self.getListDiscount()
        l_code.text = ConstantsModels.static_user?.codeInvitation
        if (ConstantsModels.static_user?.applicableInvitationCode)!{
            b_add_invitation.isHidden = false
            b_add_invitation.isEnabled = true
        }else {
            b_add_invitation.isHidden = true
            b_add_invitation.isEnabled = false

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCAddCode
        cell.l_date_discount.text = self.items[indexPath.item].caducityDate
        if self.items[indexPath.item].detail == "I" {
            cell.l_motive.text = Constants.MOTIVEV + self.items[indexPath.item].detailName
        }else if self.items[indexPath.item].detail == "V" {
            cell.l_motive.text = Constants.MOTIVEI + self.items[indexPath.item].detailName
        }
        cell.l_discount_percent.text = String(self.items[indexPath.item].percentage) + " %"
        return cell
    }
    
    @IBAction func ba_copy(_ sender: Any) {
        UIPasteboard.general.string = ConstantsModels.static_user?.codeInvitation
        let snackbar = TTGSnackbar(message: "Código copiado a portapales", duration: .middle)
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
        PakLoader.show()
        var params : Parameters
        let idUser  :UInt64 = (ConstantsModels.static_user?.idUser)!
        params = [ "IdUsuario": idUser,
                   "CodigoInvitacion": codeInvitation]
        
        
        Alamofire.request(URLs.RegisterInvitationCode, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            //hide loader
            PakLoader.hide()
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
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
        
        
        Alamofire.request(URLs.ListDiscount, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
                return
            }
            let statusCode = response.response!.statusCode
            let data = try! JSONSerialization.data(withJSONObject: response.result.value, options: .prettyPrinted)
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print(string)
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
                             
        }
    }
    
    
    func customizeNavigationBarDiscount( ) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navView = UIView()
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 25)
        label.text = "  Mis descuentos"
       
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        let image = UIImageView()
        //image.image = UIImage(named: "dwb_pak_button_discount")
        image.image = #imageLiteral(resourceName: "dwb_pak_button_discount_title")
        let imageAspect = image.image!.size.width/image.image!.size.height
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIViewContentMode.scaleAspectFit
        navView.addSubview(label)
        navView.addSubview(image)
        self.navigationItem.titleView = navView
        navView.sizeToFit()
        
       
        if ConstantsModels.count_item == 0 {
            var btnsMenuRight : [UIBarButtonItem] = []
            let btnMenuRight = UIBarButtonItem(image: UIImage(named: "dwd_pak_box_tittle_bar"), style: .plain, target: self, action: #selector(didPressRightButton))
            btnsMenuRight.append(btnMenuRight)
            self.navigationItem.rightBarButtonItems = btnsMenuRight
        }else {
            let notificationButton = SSBadgeButton()
            notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            notificationButton.setImage(UIImage(named: "dwd_pak_box_tittle_bar")?.withRenderingMode(.alwaysTemplate), for: .normal)
            notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 40)
            notificationButton.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
            notificationButton.badge = "\(ConstantsModels.count_item) "
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        }
    }
    @objc func didPressRightButtonToBox(_ sender: Any){
        self.performSegue(withIdentifier: "segue_discoutn_box" , sender: self)
    }
}
