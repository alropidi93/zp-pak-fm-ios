//
//  PakUser.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON


class UserDC : NSObject, NSCoding {
    // #MARK: Variables
    private var _idUser: UInt64 = 0
    private var _userName: String = ""
    private var _facebookID: String = ""
    private var _googleID: String = ""
    private var _names:String = ""
    private var _lastNames: String = ""
    private var _birthDate:String = ""
    private var _genere:String = ""
    private var _address:String = ""
    private var _telephone:String = ""
    private var _district: DistrictDC? = nil
    
    private var _codeInvitation: String = ""
    private var _accessToken: String = ""
    private var _smallBox: SmallBoxDC? = nil

    private var _applicableInvitationCode: Bool = true
    private var _valid: Bool = false
    
    // #MARK: Constructiors
    override init() {
    }
    
    init(_ jsonUser: JSON){
        super.init()
        self._idUser = jsonUser["IdUsuario"].uInt64 ?? self._idUser
        self._userName = jsonUser["Username"].string ?? self._userName
        self._facebookID = jsonUser["FacebookID"].string ?? self._facebookID
        self._googleID = jsonUser["GoogleID"].string ?? self._googleID
        self._names = jsonUser["Nombres"].string ?? self._names
        self._lastNames = jsonUser["Apellidos"].string ?? self._lastNames
        self._birthDate = jsonUser["FechaNacimiento"].string ?? self._birthDate
        self._genere = jsonUser["Sexo"].string ?? self._genere
        self._address = jsonUser["Direccion"].string ?? self._address
        self._telephone = jsonUser["Telefono"].string ?? self._telephone
        if !(jsonUser["Distrito"].null != nil){
            self._district = DistrictDC(jsonUser["Distrito"])
        }
        
        self._codeInvitation = jsonUser["CodigoInvitacion"].string ?? self._codeInvitation
        self._applicableInvitationCode = jsonUser["CodigoInvitacionAplicable"].bool ?? self._applicableInvitationCode
        self._accessToken = jsonUser["AccessToken"].string ?? self._userName
        
        if !(jsonUser["Cajita"].null != nil){
            self._smallBox = SmallBoxDC(jsonUser["Cajita"])
        }
    }
    
    // #MARK: Preferences management
    required init(coder decoder: NSCoder) {
        super.init()
        self._idUser = decoder.decodeObject(forKey: "IdUsuario") as? UInt64 ?? self._idUser
        self._userName = decoder.decodeObject(forKey: "Username") as? String ?? self._userName
        self._facebookID = decoder.decodeObject(forKey: "FacebookID") as? String ?? self._facebookID
        self._googleID = decoder.decodeObject(forKey: "GoogleID") as? String ?? self._googleID
        self._names = decoder.decodeObject(forKey: "Nombres") as? String ?? self._names
        self._lastNames = decoder.decodeObject(forKey: "Apellidos") as? String ?? self._lastNames
        self._birthDate = decoder.decodeObject(forKey: "FechaNacimiento") as? String ?? self._birthDate
        self._genere = decoder.decodeObject(forKey: "Sexo") as? String ?? self._genere
        self._address = decoder.decodeObject(forKey: "Direccion") as? String ?? self._address
        self._telephone = decoder.decodeObject(forKey: "Telefono") as? String ?? self._telephone
        self._district = decoder.decodeObject(forKey: "Distrito") as? DistrictDC ?? self._district
        self._codeInvitation = decoder.decodeObject(forKey: "CodigoInvitacion") as? String ?? self._codeInvitation
        self._accessToken = decoder.decodeObject(forKey: "AccessToken") as? String ?? self._accessToken
        self._smallBox = decoder.decodeObject(forKey: "Cajita") as? SmallBoxDC ?? self._smallBox
        self._applicableInvitationCode = decoder.decodeBool(forKey: "CodigoInvitacionAplicable")
        self._valid =  decoder.decodeBool(forKey: "valid")
    }
    
    func encode(with coder: NSCoder) {//
        coder.encode(_idUser, forKey: "IdUsuario")
        coder.encode(_userName, forKey: "Username")
        coder.encode(_facebookID, forKey: "FacebookID")
        coder.encode(_googleID, forKey: "GoogleID")
        coder.encode(_names, forKey: "Nombres")
        coder.encode(_lastNames, forKey: "Apellidos")
        coder.encode(_birthDate, forKey: "FechaNacimiento")
        coder.encode(_genere, forKey: "Sexo")
        coder.encode(_address,forKey: "Direccion")
        coder.encode(_telephone, forKey: "Telefono")
        coder.encode(_district, forKey: "Distrito")
        coder.encode(_codeInvitation, forKey: "CodigoInvitacionAplicable")
        coder.encode(_accessToken, forKey: "AccessToken")
        coder.encode(_smallBox, forKey: "Cajita")
        coder.encode(_valid, forKey: "valid")
    }
    
    func addValidationData(_ jsonUser: JSON){
        //TODO: Incomplete function
    }
    
    // #MARK: Accessors
    var idUser : UInt64 {
        set { _idUser = newValue}
        get {return _idUser}
    }

    var userName : String {
        set { _userName = newValue}
        get {return _userName}
    }
    
    var facebookID : String {
        set { _facebookID = newValue}
        get {return _facebookID}
    }
    
    var googleID : String {
        set { _googleID = newValue}
        get {return _googleID}
    }
    
    var names : String {
        set { _names = newValue}
        get {return _names}
    }
    
    var lastNames : String {
        set { _lastNames = newValue}
        get {return _lastNames}
    }
    
    var birthDate : String {
        set { _birthDate = newValue}
        get {return _birthDate}
    }
    
    var genere : String {
        set { _genere = newValue}
        get {return _genere}
    }
    
    var telephone : String {
        set { _telephone = newValue}
        get {return _telephone}
    }
    
    var district : DistrictDC? {
        set { _district = newValue}
        get {return _district}
    }
    
    var codeInvitation : String {
        set { _codeInvitation = newValue}
        get {return _codeInvitation}
    }
    
    var accessToken : String {
        set { _accessToken = newValue}
        get {return _accessToken}
    }
    
    var smallBox : SmallBoxDC? {
        set { _smallBox = newValue}
        get {return _smallBox}
    }
    
    var applicableInvitationCode : Bool {
        set { _applicableInvitationCode = newValue}
        get {return _applicableInvitationCode}
    }
    
    var valid : Bool {
        set {  _valid = newValue }
        get {  return _valid }
    }
    
    var address : String {
        set {  _address = newValue }
        get {  return _address }
    }
}
