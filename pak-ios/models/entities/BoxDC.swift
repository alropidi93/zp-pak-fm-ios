//
//  BoxDC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON

class BoxDC{
    private var _GUID: String = ""
    private var _items: [ItemSmallBoxDC] = []
    private var _costDelivery: Double = 0.0
    private var _discount : DiscountDC? = nil

    init() {
    }

    init(_ jsonBoxDC: JSON){
        self._GUID = jsonBoxDC["GUID"].string ?? self._GUID
        
        for (_, subJson) in jsonBoxDC["Items"]{
            let _item = ItemSmallBoxDC(subJson);
            self._items.append(_item)
        }
        
        self._costDelivery = jsonBoxDC["CostoDelivery"].double ?? self._costDelivery
        
        if !(jsonBoxDC["Descuento"].null != nil) {
            self.discount = DiscountDC(jsonBoxDC["Descuento"])
        }
    }
    
    var items : [ItemSmallBoxDC] {
        set { _items = newValue }
        get { return _items }
    }
    
    var discount : DiscountDC? {
        set { _discount = newValue }
        get { return _discount }
    }
}
