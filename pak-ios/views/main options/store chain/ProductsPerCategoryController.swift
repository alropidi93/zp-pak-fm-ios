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

class ProductsPerCategoryController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource , SendDetailProductDelegate ,NVActivityIndicatorViewable, UICollectionViewDelegateFlowLayout  {
    var categories : [CategoriesDC] = []
    
    var cant : Int = 0
    let segue_identifier : String = "segue_product_detail"
    let segue_search_view = "segue_search_view"

    private let reuse_category_identifier = "cvc_category_name"
    private let reuse_list_product_identifier = "tvc_list_products"
    
    @IBOutlet weak var cv_name_category: UICollectionView!
    @IBOutlet weak var tv_sub_categories: UITableView!
    
    private var selected_category_index : Int = 0
    
    private var indexPathSelected : IndexPath?
    private var itemProduct : ProductDC? = nil
    
    
    var searchWord : String = ""
    
    var category_width = [CGFloat]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        self.navigationController?.navigationBar.shadowImage = UIImage()

        setElements()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationBarWithSearchNew()
        tv_sub_categories.reloadData()
        cv_name_category.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.cv_name_category.delegate = self
        self.cv_name_category.dataSource = self
        
        self.tv_sub_categories.delegate = self
        self.tv_sub_categories.dataSource = self
        self.tv_sub_categories.separatorStyle = .none
        
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "dwb_pak_background_loby_amd")
        bgImage.contentMode = .scaleAspectFill
        self.tv_sub_categories.backgroundView = bgImage
        
    }
    
    //This is the controller for the category level (the product level is in each cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_category_identifier, for: indexPath) as! CVCCategoryName
        if indexPath.row == 0 {
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
        self.selected_category_index = indexPath.row
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
        
        cell.ivCornerEnd.alpha = 0
        cell.l_name_brand.text = self.categories[self.selected_category_index].list[indexPath.item].name
        cell.items = self.categories[self.selected_category_index].list[indexPath.item].product
        cell.detailProductDelegate = self
        cell.cv_products.reloadData()
        let min_width = cell.items.count * 135
        if UIScreen.main.bounds.width > CGFloat(min_width) {
            if cell.items.count != 0 {
                cell.ivCornerEnd.alpha = 1
            }
        }else {
            cell.ivCornerEnd.alpha = 0
        }
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
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                
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
                        
                        // FALTA ACTUALIZAR LA BARRA SUPERIOR
                        ConstantsModels.count_item = ConstantsModels.count_item + 1
                        self.navigationBarWithSearchNew()
                        
                        //codigo antiguo
                        /*self.cant += 1
                        var snackbar = TTGSnackbar(message: "Has agregado 1 " + product.name , duration: .middle)

                        if self.cant > 0 {
                            snackbar = TTGSnackbar(message: "Has agregado " + String(self.cant) + " unidades de " + product.name, duration: .middle)
                        }
                        snackbar.backgroundColor=UIColor.init(hexString: Constants.GREEN_PAK)
                        snackbar.show()
 */
                        
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
        }else if segue.identifier == self.segue_search_view {
            if let vc = segue.destination as? SearchView {
                vc.text = self.searchWord
            }
        }
    }
    /* #MARK: Variation of the previous one that permits you back navigation */
    func navigationBarWithSearchNew() {
        self.navigationController?.navigationBar.topItem?.title = " "
        
        var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = Constants.PLACEHOLDERSB
        
        let textFieldInsideSearchBarLabel = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBarLabel?.font = UIFont(name: "OpenSans-Light", size: 15)
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        
        
        if ConstantsModels.count_item == 0 {
            print("amdcount is 0")
            var btnsMenuRight : [UIBarButtonItem] = []
            let btnMenuRight = UIBarButtonItem(image: UIImage(named: "dwd_pak_box_tittle_bar"), style: .plain, target: self, action: #selector(didPressRightButton))
            btnsMenuRight.append(btnMenuRight)
            self.navigationItem.rightBarButtonItems = btnsMenuRight
        }else {
            print("amdcount is not 0")
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
        
        
        print("AMD cell count @ \(indexPath.row): \(indexPath)")
        print(category_width.count)
        
        return CGSize(width: (categories[indexPath.row].name.count * 10) + 16, height: 28)
    }
}
