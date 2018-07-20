//
//  RootCategoryController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/18/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import AVFoundation
import SwiftyJSON
import UIKit
import Alamofire
import AVKit
import NVActivityIndicatorView

class RootCategoriesController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NVActivityIndicatorViewable, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var cv_categories: UICollectionView!
    @IBOutlet weak var l_selected_category_title: UILabel!
    
    private let reuse_identifier = "cvc_category"
    var items : [CategoriesDC] = []
    private var selectedItems : [CategoriesDC] = []
    
    private let segue_category_sub_category = "segue_category_sub_category"
    private let segue_category_detail = "segue_category_detail"
    let segue_search_view = "segue_search_view"
    
    private var isIndexOf : Int = -1
    var selected_title : String = ""
    private var selected_sub_title : String = ""
    var searchWord : String = ""

    //#MARK: Common methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarWithSearch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {        
        self.l_selected_category_title.text = selected_title
        self.cv_categories.delegate = self
        self.cv_categories.dataSource = self
    }
    
    //#MARK: Collectionview methods and select event
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCCategory
        cell.l_name_category.text = self.items[indexPath.item].name
        UtilMethods.addGradientColor(cell.v_category_name_background)
        UtilMethods.setImage(imageview: cell.iv_category, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id_item = items[indexPath.item].idCategory
        self.selected_sub_title = items[indexPath.item].name
        getCategories(Int(id_item))
    }
    
    //Perfectly fit collection (all screens)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let itemWidth = (collectionView.bounds.size.width - marginsAndInsets).rounded(.down)
        return CGSize(width: itemWidth, height: 200)
    }
    
    func getCategories(_ selectedId :Int = -1) {
        self.isIndexOf = selectedId
        let user = ConstantsModels.static_user
        var params : Parameters
        if user != nil  && selectedId == -1 {
            let idUser  :UInt64 = (ConstantsModels.static_user?.idUser)!
            params = [ "IdUsuario": idUser]
        } else if user != nil && selectedId != -1 {
            let idUser  :UInt64 = (ConstantsModels.static_user?.idUser)!
            params = [ "IdUsuario": idUser, "IdCategoria": selectedId]
        } else if user == nil && selectedId != -1 {
            params = [ "IdCategoria": selectedId]
        } else { params = [ : ] }
        
      
        
        Alamofire.request(URLs.GetCategories, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrío un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Data"] == true { //means its a list
                        if selectedId != -1 {
                            self.selectedItems = []
                            // needs a more complex if due to possibility of 2 types of
                            for ( _ , element) in jsonResult["Categorias"] {
                                let category  = CategoriesDC(element)
                                self.selectedItems.append(category)
                            }
                            self.performSegue(withIdentifier: self.segue_category_sub_category, sender: self)
                        } else {
                            self.items = []
                            // needs a more complex if due to possibility of 2 types of
                            for ( _ , element) in jsonResult["Categorias"] {
                                let category  = CategoriesDC(element)
                                self.items.append(category)
                            }
                            self.cv_categories.reloadData()
                        }
                    } else if jsonResult["Data"] == false { //means its a grid
                        print("Fresh aca a vista compleja")
                        if selectedId != -1 {
                            for ( _ , element) in jsonResult["Categorias"] {
                                let category  = CategoriesDC(element)
                                self.selectedItems.append(category)
                            }
                            self.performSegue(withIdentifier: self.segue_category_detail, sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segue_category_sub_category {
            let vc = segue.destination as! SubCategoriesController
            vc.items = selectedItems
            self.selectedItems = []

            vc.selected_title = self.selected_sub_title
        }else if segue.identifier == self.segue_category_detail {
            let vcpl = segue.destination as! ProductsPerCategoryController
            vcpl.categories = selectedItems
            self.selectedItems = []
        } else if segue.identifier == self.segue_search_view {
            if let vc = segue.destination as? SearchView {
                vc.text = self.searchWord
            }
        }
    }
}
