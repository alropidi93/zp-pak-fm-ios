//
//  ItemOrder.swift
//  pak-ios
//
//  Created by Paolo Rossi on 7/1/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//
import Foundation
import SwiftyJSON
import AVKit

class ItemOrderDC: NSObject {
    private var _idItemPedido: Int64 = 0
    private var _SKU: String = ""
    private var _name : String = ""
    private var _cant: Int64 = 0
    private var _price: Double = 0.0
    private var _totalPrice : Double = 0.0
    private var _img: String = ""
    private var _description: String = ""
    
    override init() {}
    
    init(_ jsonOrder: JSON){
        super.init()
        self._idItemPedido = jsonOrder["IdItemPedido"].int64 ?? self._idItemPedido
        self._SKU = jsonOrder["SKU"].string ?? self._SKU
        self._name = jsonOrder["Nombre"].string ?? self._name
        self._cant = jsonOrder["Cantidad"].int64 ?? self._cant
        self._price = jsonOrder["Precio"].double ?? self._price
        self._totalPrice = jsonOrder["PrecioTotal"].double ?? self._totalPrice
        self._img = jsonOrder["Imagen"].string ?? self._img
        self._description = jsonOrder["Descripcion"].string ?? self._description
    }
    
    var idItemPedido : Int64 {
        set { _idItemPedido = newValue }
        get { return _idItemPedido }
    }
    
    var SKU : String {
        set { _SKU = newValue }
        get { return _SKU }
    }
    
    var name : String {
        set { _name = newValue }
        get { return _name }
    }
    
    var cant : Int64 {
        set { _cant = newValue }
        get { return _cant }
    }
    
    var price : Double {
        set { _price = newValue }
        get { return _price }
    }
    
    var totalPrice : Double {
        set { _totalPrice = newValue }
        get { return _totalPrice }
    }
    
    var img : String {
        set { _img = newValue }
        get { return URLs.MultimediaProductosURL + _img }
    }
    
    var description_item : String {
        set { _description = newValue }
        get { return _description }
    }
}
