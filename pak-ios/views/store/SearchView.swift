//
//  SearchView.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/16/18.
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
class SearchView : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,NVActivityIndicatorViewable {
    let segue_identifier : String = "segue_product_detail"
    private let reuse_identifier = "cvc_search_item"
    
    var text:String = ""
    var cant = 0
    
    let notificationButton = SSBadgeButton()
    
    @IBOutlet weak var l_search_word: UILabel!
    @IBOutlet weak var cv_search: UICollectionView!
    
    private var items : [ProductDC] = []
    var item : ProductDC? = nil
    var indexPath : IndexPath? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBarSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.l_search_word.text = self.text
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.cv_search.delegate = self
        self.cv_search.dataSource = self
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "dwb_pak_background_loby")
        bgImage.contentMode = .scaleToFill
        self.cv_search.backgroundView = bgImage
        getProducts()
    }
    
    //#MARK: Collectionview methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCSearchItem
        cell.l_Item_name.text = self.items[indexPath.item].name
        cell.l_price_unity.text = "S/" + String(format: "%.2f",(self.items[indexPath.item].price))
        UtilMethods.setImage(imageview: cell.iv_item_photo, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        
        
        if self.items[indexPath.item].favourite == true {
            cell.b_favorites.setImage(UIImage(named: "dwb_pak_button_hearth_red"), for: .normal)
        }else {
            cell.b_favorites.setImage(UIImage(named: "dwb_pak_button_hearth_gray"), for: .normal)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(connected(_:)))
        
        cell.iv_item_photo.isUserInteractionEnabled = true
        cell.iv_item_photo.tag = indexPath.row
        cell.iv_item_photo.addGestureRecognizer(tapGestureRecognizer)
        cell.b_add_item.tag = indexPath.row
        cell.b_add_item.addTarget(self, action: #selector(buttonAdd), for: .touchUpInside)
        cell.b_favorites.tag = indexPath.row
        cell.b_favorites.addTarget(self, action: #selector(buttonFavorite), for: .touchUpInside)
        return cell
    }
    
    
    
    @objc func connected(_ sender:AnyObject) {
        self.item = items[sender.view.tag]
        print("you tap image number : \(sender.view.tag)")
        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
        //Your code for navigate to another viewcontroller
    }
    
    @objc func buttonFavorite(sender: UIButton!) {
        let product : ProductDC = items[sender.tag]
        addOrDeleteFavortie(product,sender.tag)
    }
    
    func addOrDeleteFavortie(_ product : ProductDC, _ index : Int) {
        let user = ConstantsModels.static_user
        var params : Parameters
        if user != nil  {
            let idUser  :UInt64 = (ConstantsModels.static_user?.idUser)!
            params =  [ "IdUsuario": idUser,
                        "IdProducto": product.idProduct,
            ]
        } else {
            return
        }
        LoaderMethodsCustom.startLoaderCustom(uiViewController: self)
        
        Alamofire.request(URLs.AddOrEliminiteFavoritie, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrío un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
                return
            }
            let statusCode = response.response!.statusCode
            
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        if self.items[index].favourite == true{
                            self.items[index].favourite = false
                        } else {
                            self.items[index].favourite = true
                        }
                        let indexPath = IndexPath(item: index, section: 0)
                        self.cv_search.reloadItems(at: [indexPath])
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
    
    @objc func buttonAdd(sender: UIButton!) {
        let product : ProductDC = items[sender.tag]
        addProduct(product)
    }
    
    func addProduct(_ product : ProductDC) {
        let params: Parameters = [ "IdProducto": product.idProduct, "GUID": PreferencesMethods.getSmallBoxFromOptions()!.GUID, "Cantidad": 1]
        print(product.idProduct)
        Alamofire.request(URLs.AddItemABox, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrío un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                
                return
            }
            let statusCode = response.response!.statusCode
            
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        self.cant += 1
                        let snackbar = TTGSnackbar(message: "Se agrego " + String(self.cant) + "el producto", duration: .middle)
                        snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
                        snackbar.show()
                        ConstantsModels.count_item = ConstantsModels.count_item + 1
                        self.notificationButton.badge = "\(ConstantsModels.count_item) "
                        self.cv_search.reloadData()
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
    
    func getProducts() {
        let user = ConstantsModels.static_user
        var params : Parameters
        if user != nil  {
            let idUser  :UInt64 = (ConstantsModels.static_user?.idUser)!
            params = [ "IdUsuario": idUser,
                       "Search": self.text]
        } else {
            params = [ "Search": self.text ]
        }
        LoaderMethodsCustom.startLoaderCustom(uiViewController: self)
        
        Alamofire.request(URLs.SearchProduct, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrío un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
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
                        self.cv_search.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segue_identifier {
            if let pdc = segue.destination as? ProductsDetailController {
                pdc.item = self.item
            }
        }
    }
    
    func customizeNavigationBarSearch( ) {
        self.navigationController?.navigationBar.topItem?.title = "Resultados de busqueda"
        self.navigationController?.navigationBar.shadowImage = UIImage()
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "dwd_pak_box_tittle_bar")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 45)
        notificationButton.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
        notificationButton.badge = "\(ConstantsModels.count_item) "
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
    }    
}
