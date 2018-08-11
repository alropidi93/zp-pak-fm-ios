//
//  ProductsDetailController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/10/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView
import FacebookCore
import FacebookLogin
import SwiftHash
import SideMenu
import TTGSnackbar

class ProductsDetailController : UIViewController , NVActivityIndicatorViewable{
    @IBOutlet weak var iv_product: UIImageView!
    @IBOutlet weak var l_product_description: UILabel!
    @IBOutlet weak var l_producto_cost: UILabel!
    @IBOutlet weak var l_product_cost_total: UILabel!
    @IBOutlet weak var l_name_of_product: UILabel!
    @IBOutlet weak var b_add_favoritie: UIButton!
    @IBOutlet weak var tf_cant_add_item: UITextField!
    
    var item : ProductDC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        setElements()
    }
    
    func setElements() {
        UtilMethods.setImage(imageview: iv_product, imageurl: (self.item?.img)!, placeholderurl: "dwb-pak-logo")
        l_name_of_product.text = item?.name
        l_product_description.text = item?.descript
        let priceString : String = "S/" + String(format : "%.2f",(item?.price)!)
        l_producto_cost.text = priceString
        self.modifeTotal(Int64(tf_cant_add_item.text!)!)
        tf_cant_add_item.addTarget(self, action: #selector(textFieldEditingDidChangeEnd), for: UIControlEvents.editingDidEnd)
        self.printFavorite()
    }
    
    @objc func textFieldEditingDidChangeEnd(sender: UITextField!) {
        if sender.text?.isEmpty == false {
            let cant = Int64(sender.text!)!
            self.modifeTotal(cant)
        }
    }
    
    func modifeTotal(_ val : Int64) {
        l_product_cost_total.text = "S/" + String(format : "%.2f",(Double(val) * (item?.price)!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addOrDeleteFavortie() {
        let user = ConstantsModels.static_user
        let params: Parameters
        if user != nil  {
            let idUser  :UInt64 = (ConstantsModels.static_user?.idUser)!
            params = [ "IdUsuario": idUser, "IdProducto": item?.idProduct as Any]
        } else {
            return
        }
        
        
        Alamofire.request(URLs.AddOrEliminiteFavoritie, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        if self.item?.favourite == true{
                            self.item?.favourite = false
                        } else {
                            self.item?.favourite = true
                        }
                        self.printFavorite()
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
                            LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
        }
    }
    
    func printFavorite() {
        if self.item?.favourite == true {
            b_add_favoritie.setImage(UIImage(named: "dwb_pak_button_hearth_red"), for: .normal)
        }else {
            b_add_favoritie.setImage(UIImage(named: "dwb_ic_favorite_off_large"), for: .normal)
        }
    }
    
    func addProduct() {
        let params: Parameters = [ "IdProducto": item?.idProduct as Any, "GUID": PreferencesMethods.getSmallBoxFromOptions()!.GUID, "Cantidad": Int(tf_cant_add_item.text!)!]
        
        Alamofire.request(URLs.AddItemABox, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{

                        var cant : Int = Int(self.tf_cant_add_item.text!)!
                        if cant == 1 {
                           
                            let snackbar = TTGSnackbar(message: "Has agregado 1 " + (self.item?.name)!, duration: .middle)
                            snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
                            snackbar.show()
                            ConstantsModels.count_item = ConstantsModels.count_item + 1
                            //self.notificationButton.badge = "\(ConstantsModels.count_item) "
                        }else {
                            
                            let snackbar = TTGSnackbar(message: "Has agregado " + String(cant) + " unidades de " + (self.item?.name)!, duration: .middle)
                            snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
                            snackbar.show()
                            ConstantsModels.count_item = ConstantsModels.count_item + 1
                            //elf.notificationButton.badge = "\(ConstantsModels.count_item) "
                        }
                                            
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
                            LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
        }
    }
    
    @IBAction func b_favorite(_ sender: Any) {
        self.addOrDeleteFavortie()
    }
    
    @IBAction func b_add_box(_ sender: Any) {
        self.addProduct()
    }
}
