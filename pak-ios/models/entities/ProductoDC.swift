//
//  ProductoDC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/17/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVKit

class ProductoDC  : NSObject  {
  
    private var _idProduct: Int64 = 0
    private var _img: String = ""
    private var _SKU : String = ""
    private var _name: String = ""
    private var _descript: String = ""
    private var _price : Double = 0.0
    private var _favourite : Bool = true

    override init() {
    }
    
    init(_ jsonDiscount: JSON){
        super.init()
        self._idProduct = jsonDiscount["IdProducto"].int64 ?? self._idProduct
        self._img = jsonDiscount["Imagen"].string ?? self._img
        self._SKU = jsonDiscount["SKU"].string ?? self._SKU
        self._name = jsonDiscount["Nombre"].string ?? self._name
        self._descript = jsonDiscount["Descripcion"].string ?? self._descript
        self._price = jsonDiscount["Precio"].double ?? self._price
        self._favourite = jsonDiscount["Favorito"].bool ?? self._favourite
        
    }
    
    
    var idProduct : Int64 {
        set { _idProduct = newValue }
        get { return _idProduct }
    }
    
    var img : String {
        set { _img = newValue }
        get { return URLs.MultimediaProductosURL + _img }
    }
    var SKU : String {
        set { _SKU = newValue }
        get { return _SKU }
    }
    var name : String {
        set { _name = newValue }
        get { return _name }
    }
    var descript : String {
        set { _descript = newValue }
        get { return _descript }
    }
    var price : Double {
        set { _price = newValue }
        get { return _price }
    }
    var favourite : Bool {
        set { _favourite = newValue }
        get { return _favourite }
    }
}
