//
//  ProductsListControllers.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/19/18.
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
import GoogleSignIn
import TTGSnackbar

class ProductsPerCategoryController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource , SendDetailProductDelegate ,NVActivityIndicatorViewable  {
    var categories : [CategoriesDC] = []
    
    var cant : Int = 0
    let segue_identifier : String = "segue_product_detail"

    private let reuse_category_identifier = "cvc_category_name"
    private let reuse_list_product_identifier = "tvc_list_products"
    
    @IBOutlet weak var cv_name_category: UICollectionView!
    @IBOutlet weak var tv_sub_categories: UITableView!
    
    private var selected_category_index : Int = 0
    
    private var indexPathSelected : IndexPath?
    private var itemProduct : ProductDC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.cv_name_category.delegate = self
        self.cv_name_category.dataSource = self
        
        self.tv_sub_categories.delegate = self
        self.tv_sub_categories.dataSource = self
    }
    
    //This is the controller for the category level (the product level is in each cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_category_identifier, for: indexPath) as! CVCCategoryName
        if indexPath.item == 0 {
            cell.l_name.textColor = UIColor(named: "pak_green")
            self.indexPathSelected = indexPath
        }
        cell.l_name.text = self.categories[indexPath.item].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellselected = collectionView.cellForItem(at: self.indexPathSelected!) as! CVCCategoryName
        cellselected.l_name.textColor = UIColor(named: "pak_black")

        let cell = collectionView.cellForItem(at: indexPath) as! CVCCategoryName
        cell.l_name.textColor = UIColor(named: "pak_green")
        self.selected_category_index = indexPath.item
        self.indexPathSelected = indexPath
        self.tv_sub_categories.reloadData()
    }
    
    /* Complex view methods*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.selected_category_index == 0 {
            return self.categories[self.selected_category_index].list.count
//        } else {
//            return 1
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuse_list_product_identifier, for: indexPath as IndexPath) as! TVCSubcategory
        
        cell.l_name_brand.text = self.categories[self.selected_category_index].list[indexPath.item].name
        cell.items = self.categories[self.selected_category_index].list[indexPath.item].product
        cell.detailProductDelegate = self
        cell.cv_products.reloadData()
        return cell
    }
    
    func okButtonTapped(_ product : ProductDC){
        self.itemProduct = product
        self.performSegue(withIdentifier: self.segue_identifier, sender: self)

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
                        self.cant += 1
                        var snackbar = TTGSnackbar(message: "Has agregado 1 " + product.name , duration: .middle)

                        if self.cant > 0 {
                            snackbar = TTGSnackbar(message: "Has agregado " + String(self.cant) + " unidades de " + product.name, duration: .middle)
                        }
                        snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
                        snackbar.show()
                        ConstantsModels.count_item = ConstantsModels.count_item + 1
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segue_identifier {
            if let pdc = segue.destination as? ProductsDetailController {
                pdc.item = self.itemProduct
            }
        }
    }
}
