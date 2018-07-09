//
//  CatagoriesDC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/11/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVKit

class CategoriesDC  : NSObject  {
    // Core definition
    private var _idCategory: Int64 = 0
    private var _name: String = ""
    private var _img : String = ""
    private var _list : [ProductPerCategory] = []
    private var _category : [CategoriesDC] = []

    override init() {
    }
    
    init(_ jsonCategory: JSON) {
        super.init()
        self._idCategory = jsonCategory["IdCategoria"].int64 ?? self._idCategory
        self._name = jsonCategory["Nombre"].string ?? self._name
        self._img = jsonCategory["Imagen"].string ?? self._img
        
        for (_, subJson) in jsonCategory["Listas"] {
            let _item = ProductPerCategory(subJson);
            self._list.append(_item)
        }
        
        for (_, subJson) in jsonCategory["Items"] {
            let _item = CategoriesDC(subJson);
            self._category.append(_item)
        }
    }
    
    var idCategory : Int64 {
        set { _idCategory = newValue }
        get { return _idCategory }
    }
    
    var name : String {
        set { _name = newValue }
        get { return _name }
    }
    
    var img : String {
        set { _img = newValue }
        get { return URLs.MultimediaCategoriasURL + _img }
    }
    
    var list : [ProductPerCategory] {
        set { _list = newValue }
        get { return _list }
    }
    
    var category : [CategoriesDC] {
        set { _category = newValue }
        get { return _category }
    }
}
