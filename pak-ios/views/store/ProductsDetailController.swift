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
    
    let segue_search_view = "segue_search_view"
    var searchWord : String = ""

    var item : ProductDC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        setElements()
    }
    
    func setElements() {
        UtilMethods.setImage(imageview: iv_product, imageurl: (self.item?.img)!, placeholderurl: "no_image")
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
            var cant = Int64(sender.text!) ?? 1
            if cant < 1 {
                cant = 1
            }
            self.modifeTotal(cant)
            sender.text = "\(cant)"
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
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
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
                             
        }
    }
    
    func printFavorite() {
        if self.item?.favourite == true {
            b_add_favoritie.setImage(UIImage(named: "dwb_pak_button_hearth_red"), for: .normal)
        }else {
            //b_add_favoritie.setImage(UIImage(named: "dwb_ic_favorite_off_large"), for: .normal)
            b_add_favoritie.setImage(UIImage(named: "dwb_pak_button_hearth_gray"), for: .normal)
        }
    }
    
    func addProduct() {
        let params: Parameters = [ "IdProducto": item?.idProduct as Any, "GUID": PreferencesMethods.getSmallBoxFromOptions()!.GUID, "Cantidad": Int(tf_cant_add_item.text!)!]
        
        Alamofire.request(URLs.AddItemABox, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{

                        /*var cant : Int = Int(self.tf_cant_add_item.text!)!
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
                        }*/
                        // amd - Contador por cada item
                        //
                        //obtenemos la cajita actual del preferences local
                        let cajita = PreferencesMethods.getSmallBoxFromOptions()
                        // creamos una instancia de los items
                        var items = cajita?.items
                        var snackbar = TTGSnackbar(message: "Has agregado 1 " + (self.item?.name)! , duration: .middle)
                        var exists = false
                        // recorremos los items para ver si encontramos el producto agregado
                        for value in items!{
                            if value.idProduct == self.item?.idProduct.unsigned {
                                exists = true
                                value.cant = value.cant + Int64(self.tf_cant_add_item.text!)!.unsigned
                                snackbar = TTGSnackbar(message: "Has agregado " + String(value.cant) + " unidades de " + value.name, duration: .middle)
                                break
                            }
                        }
                        //si el item no existe, se agrega
                        if !exists {
                            let newItem = ItemSmallBoxDC()
                            //solo se agrego los datos necesarios
                            
                            if Int(self.tf_cant_add_item.text!)! > 1 {
                                snackbar = TTGSnackbar(message: "Has agregado " + self.tf_cant_add_item.text! + " unidades de " + (self.item?.name)!, duration: .middle)
                            }
                            
                            newItem.idProduct = (self.item?.idProduct.unsigned)!
                            newItem.cant = Int64(self.tf_cant_add_item.text!)!.unsigned //empieza en lo que est en el textfield
                            newItem.name = (self.self.item?.name)!
                            //...
                            items?.append(newItem)
                            
                        }
                        //sobre escribimos los items de la cajita encapsulada porque se ha editado
                        cajita?.items = items!
                        //sobre escribimos la cajita del Preferences, con la cajita encapsulada porque se ha editado
                        PreferencesMethods.saveSmallBoxToOptions(cajita!)
                        snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
                        snackbar.show()
                        //
                        //... amd
                        
                        
                        ConstantsModels.count_item = ConstantsModels.count_item + Int(self.tf_cant_add_item.text!)!
                        
                        self.navigationBarWithSearch()
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
    
    @IBAction func b_favorite(_ sender: Any) {
        self.addOrDeleteFavortie()
    }
    
    @IBAction func b_add_box(_ sender: Any) {
        self.addProduct()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationBarWithSearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == self.segue_search_view {
            if let vc = segue.destination as? SearchView {
                vc.text = self.searchWord
            }
        }
    }
    
    //device orientation override
    override var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
            print("iPad & Landscape")
            return UITraitCollection(
                traitsFrom: [UITraitCollection(horizontalSizeClass: .regular),//este es el que sirve? (no se la verdad .-.)
                    UITraitCollection(verticalSizeClass: .regular)]
            )
        }else if UIDevice.current.userInterfaceIdiom == .phone && UIDevice.current.orientation.isPortrait {
            print("iPhone & Portrait")
            return UITraitCollection(
                traitsFrom: [UITraitCollection(horizontalSizeClass: .compact),//este es el que sirve (creo ._. )
                    UITraitCollection(verticalSizeClass: .compact)]
            )
        }
        return super.traitCollection
    }
    
    
}
