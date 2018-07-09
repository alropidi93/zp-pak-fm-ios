//
//  ProductsListControllers.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/19/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import Tabman
import Pageboy
import SideMenu
import UIKit
import Alamofire

class ProductsPerCategoryController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource  {
    
    var categories : [CategoriesDC] = []
    
    private let reuse_category_identifier = "cvc_category_name"
    private let reuse_list_product_identifier = "tvc_list_products"
    
    @IBOutlet weak var cv_name_category: UICollectionView!
    @IBOutlet weak var tv_sub_categories: UITableView!
    
    private var selected_category_index : Int = 0
    
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
        cell.l_name.text = self.categories[indexPath.item].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selected_category_index = indexPath.item
        self.tv_sub_categories.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selected_category_index == 0 {
            return self.categories.count
        } else {
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selected_category_index == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuse_list_product_identifier, for: indexPath as IndexPath) as! TVCSubcategory
            cell.l_name_brand.text = self.categories[indexPath.item].name
            //cell.items = self.categories[indexPath.item].list
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuse_list_product_identifier, for: indexPath as IndexPath) as! TVCSubcategory
            cell.l_name_brand.text = self.categories[self.selected_category_index].name
            //cell.items = self.categories[indexPath.item].list
            return cell
        }
    }
}

