//
//  CVCListProduct.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/30/18.
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

class TVCSubcategory : UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource ,NVActivityIndicatorViewable{
    @IBOutlet weak var cv_products: UICollectionView!
    @IBOutlet weak var l_name_brand: UILabel!
    
    var detailProductDelegate : SendDetailProductDelegate? = nil

    
    var items : [ProductDC] = []
    var item : Int = -1
    
    private let reuse_identifier = "cvc_product"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cv_products.delegate = self
        self.cv_products.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCProduct
        UtilMethods.setImage(imageview: cell.iv_item_photo, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        cell.l_item_name.text = self.items[indexPath.item].name
        cell.l_price_unity.text = "S/" + String(format : "%.2f",(self.items[indexPath.item].price))
        cell.b_add_item.tag = indexPath.row
        cell.b_add_item.addTarget(self, action: #selector(buttonAdd), for: .touchUpInside)
        cell.b_favorites.tag = indexPath.row
        if indexPath.item == 0{
            cell.iv_start.isHidden = false
        }else if indexPath.item == items.count - 1  {
            cell.iv_end.isHidden = false
        }
        cell.b_favorites.addTarget(self, action: #selector(buttonFavorite), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       detailProductDelegate?.okButtonTapped(self.items[indexPath.item])
    }
    
    @objc func buttonAdd(sender: UIButton!) {
        let product : ProductDC = items[sender.tag]
        detailProductDelegate?.addProduct(product)
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
               // AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)
                
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
                        self.cv_products.reloadItems(at: [indexPath])
                    }
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                 //   AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                } else {
                   // AlamoMethods.defaultError(self)
                }
            }
        }
    }
    
}
