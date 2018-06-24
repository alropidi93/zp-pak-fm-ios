//
//  ListDc.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/19/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVKit

class ListDC  : NSObject {
    private var _idList: Int64 = 0
    private var _name: String = ""
    private var _sort : Int64 = 0
    private var _idCatgory : Int64 = 0
    private var _product : [ProductoDC] = []
    
    // Utility extras
    
    
    override init() {
    }
    
    init(_ jsonList: JSON){
        super.init()
        self._idList = jsonList["IdLista"].int64 ?? self._idList
        self._name = jsonList["Nombre"].string ?? self._name
        self._sort = jsonList["Orden"].int64 ?? self._sort
        self._idCatgory = jsonList["IdCategoria"].int64 ?? self._idCatgory

        for (_, subJson) in jsonList["Productos"]{
            let _item = ProductoDC(subJson);
            self._product.append(_item)
        }
    }
    
    
    var idList : Int64 {
        set { _idList = newValue }
        get { return _idList }
    }
    
    
    var name : String {
        set { _name = newValue }
        get { return _name }
    }
    
    var sort : Int64 {
        set { _sort = newValue }
        get { return _sort }
    }
    
    var idCategory : Int64 {
        set { _idCatgory = newValue }
        get { return _idCatgory }
    }
    
    var product : [ProductoDC] {
        set { _product = newValue }
        get { return _product }
    }
    
    
}
