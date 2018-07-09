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

class ProductsListControllers : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource  {
   
    var items : [CategoriesDC] = []
    var itemsPorducto : [ListDC] = []
   
    private let reuse_category_identifier = "cvc_category_name"
    private let reuse_list_product_identifier = "tvc_list_products"

    @IBOutlet weak var cv_name_category: UICollectionView!
    @IBOutlet weak var tv_list_Brand: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        tv_list_Brand.reloadData()
        itemsPorducto = items[0].list
        self.cv_name_category.delegate = self
        self.cv_name_category.dataSource = self
        self.tv_list_Brand.delegate = self
        self.tv_list_Brand.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_category_identifier, for: indexPath) as! CVCNameCategory
            cell.l_name.text = self.items[indexPath.item].name
            return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsPorducto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuse_list_product_identifier, for: indexPath as IndexPath) as! TVCListProducts
        cell.l_name_brand.text = self.itemsPorducto[indexPath.item].name
        cell.items = self.itemsPorducto[indexPath.item].product
        return cell
    }
}
