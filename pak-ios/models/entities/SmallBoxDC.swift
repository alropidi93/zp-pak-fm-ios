//
//  BoxDC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON

class SmallBoxDC  : NSObject ,NSCoding{
    private var _GUID: String = ""
    private var _items: [ItemSmallBoxDC] = []
    private var _costDelivery: Double = 0.0
    private var _discount : DiscountDC? = nil

    override init() {
    }
  
    init(_ jsonSmallBoxDC: JSON){
        super.init()
        self._GUID = jsonSmallBoxDC["GUID"].string ?? self._GUID
        for (_, subJson) in jsonSmallBoxDC["Items"]{
            let _item = ItemSmallBoxDC(subJson);
            self._items.append(_item)
        }
        self._costDelivery = jsonSmallBoxDC["CostoDelivery"].double ?? self._costDelivery
        
        if !(jsonSmallBoxDC["Descuento"].null != nil) {
            self.discount = DiscountDC(jsonSmallBoxDC["Descuento"])
        }
    }
    
    required init(coder decoder: NSCoder) {         // PREFERENCES
        super.init()
        self._GUID = decoder.decodeObject(forKey: "GUID") as? String ?? self._GUID
        self._items = decoder.decodeObject(forKey: "Items") as? [ItemSmallBoxDC] ?? self._items
        self._costDelivery = decoder.decodeObject(forKey: "CostoDelivery") as? Double ?? self._costDelivery
        self._discount = decoder.decodeObject(forKey: "Descuento") as? DiscountDC? ?? self._discount

    }
    
    
    func encode(with coder: NSCoder) {//
        coder.encode(_GUID, forKey: "GUID")
        coder.encode(_items, forKey: "Items")
        coder.encode(_costDelivery, forKey: "CostoDelivery")
        coder.encode(_discount, forKey: "Descuento")

    }
    
    var GUID : String {
        set { _GUID = newValue }
        get { return _GUID }
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
