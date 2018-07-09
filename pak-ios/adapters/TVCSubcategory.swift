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
    
    //    let segue_identifier = "segue_todelivery_todetail"
    var items : [ProductDC] = []
    var item : Int = -1
    
    private let reuse_identifier = "cvc_product"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setElements()
    }
   
    func setElements() {
        self.cv_products.delegate = self
        self.cv_products.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCProduct
        UtilMethods.setImage(imageview: cell.iv_product, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        return cell
    }
}
