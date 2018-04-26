//
//  DistrictDC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON

class DistrictDC {
    
    private var _idDistrict: UInt64 = 0
    private var _name: String = ""
    private var _deliveryArrives: Bool = true
    
    init() {
    }
    
    init(_ jsonDistrict: JSON){
        self._idDistrict = jsonDistrict["IdDistrito"].uInt64 ?? self._idDistrict
        self._name = jsonDistrict["Nombre"].string ?? self._name

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
