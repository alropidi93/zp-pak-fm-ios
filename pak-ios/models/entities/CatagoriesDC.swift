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
    //     private var _listAds: [listDC] = []
    //     private var _listAds: [CategoriesDC] = []

    
    
    override init() {
    }
    
    init(_ jsonDiscount: JSON){
        super.init()
        self._idCategory = jsonDiscount["IdCategoria"].int64 ?? self._idCategory
        self._name = jsonDiscount["Nombre"].string ?? self._name
        self._img = jsonDiscount["Imagen"].string ?? self._img
        
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
    
    
    
}
