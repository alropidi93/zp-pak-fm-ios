//
//  StoreController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/3/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import AVFoundation
import SwiftyJSON
import UIKit
import Alamofire
import AVKit
import NVActivityIndicatorView

class StoreController : UIViewController, UICollectionViewDelegate,  UICollectionViewDataSource, NVActivityIndicatorViewable, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var cv_categories: UICollectionView!
    
    private let reuse_identifier = "cvc_category"
    private var items : [CategoriesDC] = []
    private var selectedItems : [CategoriesDC] = []
    
    /*holiwiw ¡ =)*/
    
    var itemsAll : CategoriesDC  = CategoriesDC()
    
    
    /*holiwiw chau ¡ =)*/
    
    private let segue_category_sub_category = "segue_category_sub_category"
    private let segue_category_detail = "segue_category_detail"
    
    private var isIndexOf : Int = -1
    private var selected_title : String = ""
    
    //#MARK: Common methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.cv_categories.delegate = self
        self.cv_categories.dataSource = self
        getCategories()
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
        self.selected_title = items[indexPath.item].name
        getCategories(Int(id_item))
    }
    
    //Perfectly fit collection (all screens)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let itemWidth = (collectionView.bounds.size.width - marginsAndInsets).rounded(.down)
        return CGSize(width: itemWidth, height: 200)*/
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            return CGSize(width: (UIScreen.main.bounds.width/2) - 0.5, height: 200)
        }else{
            return CGSize(width: UIScreen.main.bounds.width, height: 200)
        }
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
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    print(jsonResult["Data"])
                    print(selectedId)
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
                                
                                
                                print(category.idCategory)
                            }
                            self.cv_categories.reloadData()
                        }
                    } else if jsonResult["Data"] == false { //means its a grid
                        print("Fresh aca a vista compleja")
                        if selectedId != -1 {
                            self.selectedItems = []
                            // needs a more complex if due to possibility of 2 types of
                            for ( _ , element) in jsonResult["Categorias"] {
                                let category  = CategoriesDC(element)
                                self.selectedItems.append(category)
                            }
                            self.createAll()

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
                             
        }
    }
    
    func createAll(){
        itemsAll.list = []
        itemsAll.name = "Todos"
        for itemI in self.selectedItems{
            for itemJ in itemI.list{
                itemsAll.list.append(itemJ)
            }
        }
        selectedItems.insert(itemsAll, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segue_category_sub_category {
            let vc = segue.destination as! SubCategoriesController
            vc.items = selectedItems
            self.selectedItems = []

            vc.selected_title = self.selected_title
        }else if segue.identifier == self.segue_category_detail {
            let vcpl = segue.destination as! ProductsPerCategoryController
            vcpl.categories = selectedItems
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

