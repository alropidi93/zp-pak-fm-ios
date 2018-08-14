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

class SearchView : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,NVActivityIndicatorViewable, UICollectionViewDelegateFlowLayout  {
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
        print("AMD: \(String(describing: type(of: self)))")
        self.l_search_word.text = "\"" + self.text + "\""
        //setElements() //moved to viewDidAppear
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.cv_search.delegate = self
        self.cv_search.dataSource = self
        let bgImage = UIImageView();
        //amd - replaced new horizontal background, and aspect fix
        bgImage.image = UIImage(named: "dwb_pak_background_loby_amd")
        bgImage.contentMode = .scaleAspectFill
        self.cv_search.backgroundView = bgImage
        
        getProducts()
    }
    
    //#MARK: Collectionview methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCSearchItem
        
        //amd - cell width equal to 1/3 of screen size
        //este fix no servia para pantallas pequenas, se agrego un delegate
        /*
         let cell_width = UIScreen.main.bounds.width/3
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell_width, cell.frame.height)
        */
        
        cell.l_Item_name.text = self.items[indexPath.item].name
        cell.l_price_unity.text = "S/" + String(format: "%.2f",(self.items[indexPath.item].price))
        UtilMethods.setImage(imageview: cell.iv_item_photo, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        
        
        if self.items[indexPath.item].favourite == true {
            cell.b_favorites.setImage(UIImage(named: "dwb-ic_favorite_on"), for: .normal)
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
        //todo - fix counter per product
        print("AMD: \(items.count)")
        print("AMD: \(items[0].idProduct)")
        //...
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
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                
                return
            }
            let statusCode = response.response!.statusCode
            
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        if self.cant == 1 {
                            self.cant += 1
                            let snackbar = TTGSnackbar(message: "Has agregado 1 " + product.name, duration: .middle)
                            snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
                            snackbar.show()
                            print(ConstantsModels.count_item)
                            ConstantsModels.count_item += 1
                            print(ConstantsModels.count_item)
                            self.customizeNavigationBarSearch()
                        }else {
                            self.cant += 1
                            let snackbar = TTGSnackbar(message: "Has agregado " + String(self.cant) + " unidades de " + product.name, duration: .middle)
                            snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
                            snackbar.show()
                            print(ConstantsModels.count_item)
                            ConstantsModels.count_item += 1
                            print(ConstantsModels.count_item)
                            self.notificationButton.badge = "\(ConstantsModels.count_item) "
                            self.customizeNavigationBarSearch()

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
        Alamofire.request(URLs.SearchProduct, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
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
        self.navigationController?.navigationBar.shadowImage = UIImage()

        let navView = UIView()
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = UIColor(rgb: 0x81D34C)
        label.text = "Resultados de búsqueda"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        navView.addSubview(label)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Log 8: Columnas responsive
        let cell_width = UIScreen.main.bounds.width/3
        return CGSize(width: cell_width, height: 230)
    }
    
}
