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
    
    private let reuse_identifier = "cvc_search_item"
    var text:String = ""
    
    @IBOutlet weak var l_search_word: UILabel!
    @IBOutlet weak var cv_search: UICollectionView!
   
    private var items : [ProductoDC] = []
    
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
    
    func setElements(){
        self.cv_search.delegate = self
        self.cv_search.dataSource = self
        getProducts()
    }
    
    //#MARK: Collectionview methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCSearchItem
        cell.l_Item_name.text = self.items[indexPath.item].name
        cell.l_price_unity.text = "\(self.items[indexPath.item].price)"
        UtilMethods.setImage(imageview: cell.iv_item_photo, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        
        
        if self.items[indexPath.item].favourite == true {
            cell.b_favorites.setImage(UIImage(named: "dwb_pak_button_hearth_red"), for: .normal)
        }else {
            cell.b_favorites.setImage(UIImage(named: "dwb_pak_button_hearth_gray"), for: .normal)
        }
        
        self.indexPath = indexPath
        
        cell.b_add_item.tag = indexPath.row
        cell.b_add_item.addTarget(self, action: #selector(buttonAdd), for: .touchUpInside)
        cell.b_favorites.tag = indexPath.row
        cell.b_favorites.addTarget(self, action: #selector(buttonFavorite), for: .touchUpInside)
        return cell
    }
    @objc func buttonFavorite(sender: UIButton!) {
        let product : ProductoDC = items[sender.tag]
        addOrDeleteFavortie(product,sender.tag)
    }
    func addOrDeleteFavortie(_ product : ProductoDC, _ index : Int){
        
        let user = PreferencesMethods.getUserFromOptions()
        var params : Parameters
        if user != nil  {
            let idUser  :UInt64 = (PreferencesMethods.getUserFromOptions()?.idUser)!
            params =  [ "IdUsuario": idUser,
              "IdProducto": product.idProduct,
              ]
        } else {
            return
        }
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        Alamofire.request(URLs.AddOrEliminiteFavoritie, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
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
                        if self.items[index].favourite == true{
                            self.items[index].favourite = false
                        } else {
                            self.items[index].favourite = true
                        }
                      self.cv_search.reloadItems(at: [self.indexPath!])
                  }
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["message"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
    
    @objc func buttonAdd(sender: UIButton!) {
        let product : ProductoDC = items[sender.tag]
        addProduct(product)
        
    }
    func addProduct(_ product : ProductoDC){
        let params: Parameters = [ "IdProducto": product.idProduct,
                                   "GUID": PreferencesMethods.getSmallBoxFromOptions()!.GUID,
                                   "Cantidad": 1]
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        Alamofire.request(URLs.AddItemABox, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
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
                        let snackbar = TTGSnackbar(message: "Se agrego el producto", duration: .middle)
                        snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
                        snackbar.show()
                        self.cv_search.reloadData()
                    }
                }
            } else {
                
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["message"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
    
    func getProducts() {
        
        let user = PreferencesMethods.getUserFromOptions()
        var params : Parameters
        if user != nil  {
            let idUser  :UInt64 = (PreferencesMethods.getUserFromOptions()?.idUser)!
            params = [ "IdUsuario": idUser,
            "Search": self.text]
        } else {
            params = [ "Search": self.text ]
        }
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        Alamofire.request(URLs.SearchProduct, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
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
                        self.items = []
                        for ( _ , element) in jsonResult["Productos"] {
                            let producto  = ProductoDC(element)
                            self.items.append(producto)
                        }
                        
                        self.cv_search.reloadData()
                    }
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["message"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
}