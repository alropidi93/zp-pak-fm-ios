//
//  CVCListProduct.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/30/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class TVCSubcategory : UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
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
        cell.l_price_unity.text = "S/" + "\(self.items[indexPath.item].price)"
        cell.b_add_item.tag = indexPath.row
        cell.b_add_item.addTarget(self, action: #selector(buttonAdd), for: .touchUpInside)
        cell.b_favorites.tag = indexPath.row
//        cell.b_favorites.addTarget(self, action: #selector(buttonFavorite), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       detailProductDelegate?.okButtonTapped(self.items[indexPath.item])
    }
    
    @objc func buttonAdd(sender: UIButton!) {
        let product : ProductDC = items[sender.tag]
        detailProductDelegate?.addProduct(product)
    }
    
//    @objc func buttonFavorite(sender: UIButton!) {
//        let product : ProductDC = items[sender.tag]
//        addOrDeleteFavortie(product,sender.tag)
//    }
    
    
}
