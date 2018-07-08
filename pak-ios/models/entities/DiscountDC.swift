//
//  DiscountDC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON

class DiscountDC : NSObject ,NSCoding {
    private var _percentage : Double = 0.0
    private var _caducityDate : String = ""
    private var _status : String = ""
    private var _detail : String = ""
    private var _detailName : String = ""
    
    override init() {
    }
    
    init(_ jsonDiscount: JSON) {
        super.init()
        self._percentage = jsonDiscount["Porcentaje"].double ?? self._percentage
        self._caducityDate = jsonDiscount["FechaCaducidad"].string ?? self._caducityDate
        self._status = jsonDiscount["Estado"].string ?? self._status
        self._detail = jsonDiscount["Motivo"].string ?? self._detail
        self._detailName = jsonDiscount["NombreMotivo"].string ?? self._detailName
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        self._percentage = decoder.decodeObject(forKey: "Porcentaje") as? Double ?? self._percentage
        self._caducityDate = decoder.decodeObject(forKey: "FechaCaducidad") as? String ?? self._caducityDate
        self._status = decoder.decodeObject(forKey: "Estado") as? String ?? self._status
        self._detail = decoder.decodeObject(forKey: "Motivo") as? String ?? self._detail
        self._detailName = decoder.decodeObject(forKey: "NombreMotivo") as? String ?? self._detailName
    }
    
    func encode(with coder: NSCoder) {//
        coder.encode(_percentage, forKey: "Porcentaje")
        coder.encode(_caducityDate, forKey: "FechaCaducidad")
        coder.encode(_status, forKey: "Estado")
        coder.encode(_detail, forKey: "Motivo")
        coder.encode(_detailName, forKey: "NombreMotivo")
    }
    
    var percentage :Double {
        set { _percentage = newValue }
        get { return _percentage }
    }
    
    var caducityDate : String {
        set { _caducityDate = newValue }
        get { return _caducityDate }
    }
    
    var status : String {
        set { _status = newValue }
        get { return _status }
    }
    
    var detail : String {
        set { _detail = newValue }
        get { return _detail }
    }
    
    var detailName : String {
        set { _detailName = newValue }
        get { return _detailName }
    }
}
