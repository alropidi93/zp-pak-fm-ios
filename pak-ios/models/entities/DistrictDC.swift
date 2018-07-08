//
//  DistrictDC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON

class DistrictDC : NSObject, NSCoding {
    private var _idDistrict: UInt64 = 0
    private var _name: String = ""
    private var _deliveryArrives: Bool = true
    
    override init() {
    }
    
    init(_ jsonDistrict: JSON) {
        super.init()
        self._idDistrict = jsonDistrict["IdDistrito"].uInt64 ?? self._idDistrict
        self._name = jsonDistrict["Nombre"].string ?? self._name
        self._deliveryArrives = jsonDistrict["LlegaDelivery"].bool ?? self._deliveryArrives
    }
    
    required init(coder decoder: NSCoder) {         // PREFERENCES
        super.init()
        self._idDistrict = decoder.decodeObject(forKey: "IdDistrito") as? UInt64 ?? self._idDistrict
        self._name = decoder.decodeObject(forKey: "Nombre") as? String ?? self._name
        self._deliveryArrives = decoder.decodeObject(forKey: "LlegaDelivery") as? Bool ?? self._deliveryArrives
    }
    
    
    func encode(with coder: NSCoder) {//
        coder.encode(_idDistrict, forKey: "IdDistrito")
        coder.encode(_name, forKey: "Nombre")
        coder.encode(_deliveryArrives, forKey: "LlegaDelivery")
    }
    
    var idDistrict : UInt64 {
        set { _idDistrict = newValue}
        get {return _idDistrict}
    }
    var name : String {
        set { _name = newValue}
        get {return _name}
    }
    var deliveryArrives : Bool {
        set { _deliveryArrives = newValue}
        get {return _deliveryArrives}
    }
}
