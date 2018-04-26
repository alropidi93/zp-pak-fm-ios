//
//  ItemSmallBox.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON

class ItemSmallBoxDC{
    private var _idProduct : UInt64 = 0
    private var _cant: UInt64 = 0
    private var _img: String = ""
    private var _SKU: String = ""
    private var _name: String = ""
    private var _description: String = ""
    private var _price: Double = 0.0

    init(){
        
    }
    
    init(_ jsonItemSmallBoxDC: JSON){
        self._idProduct = jsonItemSmallBoxDC["IdProducto"].uInt64 ?? self._idProduct
        self._cant = jsonItemSmallBoxDC["Cantidad"].uInt64 ?? self._cant
        self._img = jsonItemSmallBoxDC["Imagen"].string ?? self._img
        self._SKU = jsonItemSmallBoxDC["SKU"].string ?? self._SKU
        self._name = jsonItemSmallBoxDC["Nombre"].string ?? self._name
        self._description = jsonItemSmallBoxDC["Descripcion"].string ?? self._description
        self._price = jsonItemSmallBoxDC["Precio"].double ?? self._price
    }

    var idProduct : UInt64 {
        set { _idProduct = newValue }
        get { return _idProduct }
    }
    
    var cant : UInt64 {
        set { _cant = newValue }
        get { return _cant }
    }
    
    var img : String {
        set { _img = newValue }
        get { return _img }
    }
    
    var SKU : String {
        set { _SKU = newValue }
        get { return _SKU }
    }
    
    var name : String {
        set { _name = newValue }
        get { return _name }
    }
    
    var description : String {
        set { _description = newValue }
        get { return _description }
    }
    
    var price : Double {
        set { _price = newValue }
        get { return _price }
    }
    
    
}


