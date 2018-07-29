//
//  CVCProducts.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/30/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
class CVCProduct : UICollectionViewCell {

    @IBOutlet var iv_item_photo: UIImageView!
    @IBOutlet var l_item_name: UILabel!
    @IBOutlet var l_price_unity: UILabel!
    @IBOutlet var b_add_item: UIButton!
    @IBOutlet var b_favorites: UIButton!
    @IBOutlet weak var iv_start: UIImageView!
    @IBOutlet weak var iv_end: UIImageView!
}
