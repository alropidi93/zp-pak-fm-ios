//
//  CheckOut.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/22/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
class CheckOut: NSObject {
    private var _GUID: String = ""
    private var _address: String = ""
    private var _district : Int64 = 0
    private var _reference : String = ""
    private var _facturationType: String = ""
    private var _ruc: String = ""
    private var _businessName : String = ""
    private var _fiscalAddress : String = ""
    private var _recipentName: String = ""
    private var _date : String = ""
    private var _hourlySale : String = ""
    private var _token : String = ""

    
    
    var GUID : String {
        set { _GUID = newValue }
        get { return _GUID }
    }
    var address : String {
        set { _address = newValue }
        get { return _address }
    }
    var reference : String {
        set { _reference = newValue }
        get { return _reference }
    }
    var facturationType : String {
        set { _facturationType = newValue }
        get { return _facturationType }
    }
    var ruc : String {
        set { _ruc = newValue }
        get { return _ruc }
    }
    var businessName : String {
        set { _businessName = newValue }
        get { return _businessName }
    }
    var fiscalAddress : String {
        set { _fiscalAddress = newValue }
        get { return _fiscalAddress }
    }
    var recipentName : String {
        set { _recipentName = newValue }
        get { return _recipentName }
    }
    var date : String {
        set { _date = newValue }
        get { return _date }
    }
    var hourlySale : String {
        set { _hourlySale = newValue }
        get { return _hourlySale }
    }
    var token : String {
        set { _token = newValue }
        get { return _token }
    }
    
    var district : Int64 {
        set { _district = newValue }
        get { return _district }
    }
   
    
    
}
