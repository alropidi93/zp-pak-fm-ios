//
//   FavouriteController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/21/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftHash
import SideMenu

class FavouriteController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,NVActivityIndicatorViewable {
    
    private let reuse_identifier = "cvc_favourite_item"
    
    
    @IBOutlet weak var cv_favorite: UICollectionView!
    
    
    private var items : [ProductoDC] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBarFavourite()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setElements(){
        self.cv_favorite.delegate = self
        self.cv_favorite.dataSource = self
        
        getFavourite()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCFavouriteItem
        cell.l_item_name.text = self.items[indexPath.item].name
        cell.l_price_unity.text = "\(self.items[indexPath.item].price)"
        UtilMethods.setImage(imageview: cell.iv_item_photo, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
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
        let user = ConstantsModels.UserStatic
        let params: Parameters
        if user != nil  {
            let idUser  :UInt64 = (ConstantsModels.UserStatic?.idUser)!
            params = [ "IdUsuario": idUser,
                       "IdProducto": product.idProduct]
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
                        //make a toast or something
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
            self.stopAnimating()
        }
    }

    func getFavourite() {
        var params : Parameters
        let idUser  :UInt64 = (ConstantsModels.UserStatic?.idUser)!
            print(idUser)
            params = [ "IdUsuario": idUser]
            print("holaaa")
       
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        Alamofire.request(URLs.ListFavoritie, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            
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
            self.stopAnimating()
        }
    }
    
}
