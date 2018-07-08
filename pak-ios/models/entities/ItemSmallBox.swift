//
//  ItemSmallBox.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON

class ItemSmallBoxDC : NSObject ,NSCoding{
    private var _idProduct : UInt64 = 0
    private var _cant: UInt64 = 0
    private var _img: String = ""
    private var _SKU: String = ""
    private var _name: String = ""
    private var _description: String = ""
    private var _price: Double = 0.0

    override init() {
    }
    
    init(_ jsonItemSmallBoxDC: JSON) {
        super.init()
        self._idProduct = jsonItemSmallBoxDC["IdProducto"].uInt64 ?? self._idProduct
        self._cant = jsonItemSmallBoxDC["Cantidad"].uInt64 ?? self._cant
        self._img = jsonItemSmallBoxDC["Imagen"].string ?? self._img
        self._SKU = jsonItemSmallBoxDC["SKU"].string ?? self._SKU
        self._name = jsonItemSmallBoxDC["Nombre"].string ?? self._name
        self._description = jsonItemSmallBoxDC["Descripcion"].string ?? self._description
        self._price = jsonItemSmallBoxDC["Precio"].double ?? self._price
    }
    
    
    required init(coder decoder: NSCoder) {
        super.init()
        self._idProduct = decoder.decodeObject(forKey: "IdProducto") as? UInt64 ?? self._idProduct
        self._cant = decoder.decodeObject(forKey: "Cantidad") as? UInt64 ?? self._cant
        self._img = decoder.decodeObject(forKey: "Imagen") as? String ?? self._img
        self._SKU = decoder.decodeObject(forKey: "SKU") as? String ?? self._SKU
        self._name = decoder.decodeObject(forKey: "Nombre") as? String ?? self._name
        self._description = decoder.decodeObject(forKey: "Descripcion") as? String ?? self._description
        self._price = decoder.decodeObject(forKey: "Precio") as? Double ?? self._price
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(_idProduct, forKey: "IdProducto")
        coder.encode(_cant, forKey: "Cantidad")
        coder.encode(_img, forKey: "Imagen")
        coder.encode(_SKU, forKey: "SKU")
        coder.encode(_name, forKey: "Nombre")
        coder.encode(_description, forKey: "Descripcion")
        coder.encode(_price, forKey: "Precio")
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
    
    var boxDescription : String {
        set { _description = newValue }
        get { return _description }
    }
    
    var price : Double {
        set { _price = newValue }
        get { return _price }
    }
    
    
}


