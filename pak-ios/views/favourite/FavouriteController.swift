//
//  FavouriteController.swift
//  pak-ios
//
//  Created by italo on 9/07/18.
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

class FavouriteController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,NVActivityIndicatorViewable, UICollectionViewDelegateFlowLayout {

    private let reuse_identifier = "cvc_favourite_item"
    //var cant = 0
    
    @IBOutlet weak var cv_favorite: UICollectionView!
    private var items : [ProductDC] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        customizeNavigationBarFavourite()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        self.customizeNavigationBarFavourite()
        setElements()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.setNeedsLayout()

        self.customizeNavigationBarFavourite()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setElements(){
        self.cv_favorite.delegate = self
        self.cv_favorite.dataSource = self
        let bgImage = UIImageView();
        //amd - background and aspect fix
        bgImage.image = UIImage(named: "dwb_pak_background_loby_amd")
        bgImage.contentMode = .scaleAspectFill
        self.cv_favorite.backgroundView = bgImage
        
        getFavourite()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCFavouriteItem
        
        cell.l_item_name.text = self.items[indexPath.item].name
        cell.l_price_unity.text = "S/" + String(format : "%.2f",(self.items[indexPath.item].price))

        UtilMethods.setImage(imageview: cell.iv_item_photo, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        cell.b_add_item.tag = indexPath.row
        cell.b_add_item.addTarget(self, action: #selector(buttonAdd), for: .touchUpInside)
        cell.b_favorites.tag = indexPath.row
        cell.b_favorites.addTarget(self, action: #selector(buttonFavorite), for: .touchUpInside)
        return cell
    }
    @objc func buttonFavorite(sender: UIButton!) {
        let product : ProductDC = items[sender.tag]
        addOrDeleteFavortie(product,sender.tag)

    }
    func addOrDeleteFavortie(_ product : ProductDC, _ index : Int){
        let user = ConstantsModels.static_user
        let params: Parameters
        if user != nil  {
            let idUser  :UInt64 = (ConstantsModels.static_user?.idUser)!
            params = [ "IdUsuario": idUser,
                       "IdProducto": product.idProduct]
        } else {
            return
        }

        Alamofire.request(URLs.AddOrEliminiteFavoritie, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        self.items.remove(at: index)
                        self.cv_favorite.reloadData()
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
    @objc func buttonAdd(sender: UIButton!) {
        let product : ProductDC = items[sender.tag]
        addProduct(product)

    }
    func addProduct(_ product : ProductDC){
        let params: Parameters = [ "IdProducto": product.idProduct,
                                   "GUID": PreferencesMethods.getSmallBoxFromOptions()!.GUID,
                                   "Cantidad": 1]
        
        Alamofire.request(URLs.AddItemABox, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)
                
                
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        // amd - Contador por cada item
                        //
                        //obtenemos la cajita actual del preferences local
                        let cajita = PreferencesMethods.getSmallBoxFromOptions()
                        // creamos una instancia de los items
                        var items = cajita?.items
                        var snackbar = TTGSnackbar(message: "Has agregado 1 " + product.name , duration: .middle)
                        var exists = false
                        // recorremos los items para ver si encontramos el producto agregado
                        for item in items!{
                            if item.idProduct == product.idProduct {
                                exists = true
                                item.cant = item.cant + 1
                                snackbar = TTGSnackbar(message: "Has agregado " + String(item.cant) + " unidades de " + item.name, duration: .middle)
                                break
                            }
                        }
                        //si el item no existe, se agrega
                        if !exists {
                            let newItem = ItemSmallBoxDC()
                            //solo se agrego los datos necesarios
                            newItem.idProduct = UInt64(product.idProduct)
                            newItem.cant = 1 //empieza en 1
                            newItem.name = product.name
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
                        
                        //Código antiguo
                        /*self.cant += 1
                        var snackbar = TTGSnackbar(message: "Has agregado 1 " + product.name , duration: .middle)
                        
                        if self.cant > 0 {
                            snackbar = TTGSnackbar(message: "Has agregado " + String(self.cant) + " unidades de " + product.name, duration: .middle)
                        }
                        snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
                        snackbar.show()*/
                        //...
                        
                        ConstantsModels.count_item = ConstantsModels.count_item + 1
                        self.cv_favorite.reloadData()
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

    func getFavourite() {
        var params : Parameters
        let idUser  :UInt64 = (ConstantsModels.static_user?.idUser)!
        print(idUser)
        params = [ "IdUsuario": idUser]
        print("holaaa")



        Alamofire.request(URLs.ListFavoritie, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in

            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        self.items = []
                        for ( _ , element) in jsonResult["Productos"] {
                            let producto  = ProductDC(element)
                            self.items.append(producto)
                        }
                        self.cv_favorite.reloadData()
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

    func customizeNavigationBarFavourite( ) {

        let navView = UIView()
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 20)

        label.text = "  Mis Favoritos"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        let image = UIImageView()
        image.image = UIImage(named: "dwb_pak_button_favorites")
        let imageAspect = image.image!.size.width/image.image!.size.height
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIViewContentMode.scaleAspectFit
        navView.addSubview(label)
        navView.addSubview(image)
        self.navigationItem.titleView = navView
        navView.sizeToFit()

        let notificationButton = SSBadgeButton()
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "dwd_pak_box_tittle_bar")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 40)
        notificationButton.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)

       print(ConstantsModels.count_item)
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

    @objc func didPressRightButtonBox(_ sender: Any){
        self.performSegue(withIdentifier: "segue_small_order_box" , sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Log 8: Columnas responsive
        let cell_width = UIScreen.main.bounds.width/3
        return CGSize(width: cell_width, height: 230)
    }

}
