//
//  OrderDC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 7/1/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVKit

class OrderDC  : NSObject {
    private var _number: Int64 = 0
    private var _address: String = ""
    private var _district : DistrictDC? = nil
    private var _reference : String = ""
    private var _facturationType: String = ""
    private var _ruc: String = ""
    private var _socialReason : String = ""
    private var _fiscalAddress : String = ""
    private var _discount: DiscountDC? = nil
    private var _destinataryName: String = ""
    private var _phone : String = ""
    private var _email : String = ""
    private var _score: Int64 = 0
    private var _subTotal: Double = 0.0
    private var _total : Double = 0.0
    private var _dateOfDelivery : String = ""
    private var _distributionHour: DistributionHour? = nil
    private var _state : String = ""
    private var _dateToRecive : String = ""
    private var _dateRecive: String = ""
    private var _dateCancel: String = ""
    private var _items : [ItemOrderDC] = []
    private var _deliveryCost : Double = 0.0
    private var _dateHourMaxAnulation : String = ""

    override init() {}
    
    init(_ jsonOrder: JSON){
        super.init()
        self._number = jsonOrder["Numero"].int64 ?? self._number
        self._address = jsonOrder["Direccion"].string ?? self._address
        
        if !(jsonOrder["Distrito"].null != nil) {
            self._district = DistrictDC(jsonOrder["Distrito"])
        }
        self._reference = jsonOrder["Referencia"].string ?? self._reference
        self._facturationType = jsonOrder["TipoFacturacion"].string ?? self._facturationType
        self._ruc = jsonOrder["RUC"].string ?? self._ruc
        self._socialReason = jsonOrder["RazonSocial"].string ?? self._socialReason
        self._fiscalAddress = jsonOrder["DireccionFiscal"].string ?? self._fiscalAddress
        
        if !(jsonOrder["Descuento"].null != nil) {
            self._discount = DiscountDC(jsonOrder["Descuento"])
        }
        
        self._destinataryName = jsonOrder["NombresDestinatario"].string ?? self._destinataryName
        self._phone = jsonOrder["Telefono"].string ?? self._phone
        self._email = jsonOrder["Email"].string ?? self._email
        self._score = jsonOrder["Calificacion"].int64 ?? self._score
        self._subTotal = jsonOrder["Subtotal"].double ?? self._subTotal
        self._total = jsonOrder["Total"].double ?? self._total
        self._dateOfDelivery = jsonOrder["FechaEntrega"].string ?? self._dateOfDelivery
        
        if !(jsonOrder["HorarioReparto"].null != nil) {
            self._distributionHour = DistributionHour(jsonOrder["HorarioReparto"])
        }
        
        self._state = jsonOrder["Estado"].string ?? self._state
        self._dateToRecive = jsonOrder["FechaHoraPedido"].string ?? self._dateToRecive
        self._dateRecive = jsonOrder["FechaHoraEntregado"].string ?? self._dateRecive
        self._dateCancel = jsonOrder["FechaHoraAnulado"].string ?? self._dateCancel
        
        
        for (_, subJson) in jsonOrder["Items"]{
            let _item = ItemOrderDC(subJson);
            self._items.append(_item)
        }
        
        self._deliveryCost = jsonOrder["CostoDelivery"].double ?? self._deliveryCost
        self._dateHourMaxAnulation = jsonOrder["FechaHoraMaximaAnulacion"].string ?? self._dateHourMaxAnulation
        
    }
    
    
    var number : Int64 {
        set { _number = newValue }
        get { return _number }
    }
    var address : String {
        set { _address = newValue }
        get { return _address }
    }
    var district : DistrictDC? {
        set { _district = newValue }
        get { return _district }
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
    
    var socialReason : String {
        set { _socialReason = newValue }
        get { return _socialReason }
    }
    
    var fiscalAddress : String {
        set { _fiscalAddress = newValue }
        get { return _fiscalAddress }
    }
    
    var discount : DiscountDC?{
        set { _discount = newValue }
        get { return _discount }
    }
    
    var destinataryName : String {
        set { _destinataryName = newValue }
        get { return _destinataryName }
    }
    
    var phone : String {
        set { _phone = newValue }
        get { return _phone }
    }
    
    var email : String {
        set { _email = newValue }
        get { return _email }
    }
    var score : Int64 {
        set { _score = newValue }
        get { return _score }
    }
    
    var subTotal : Double {
        set { _subTotal = newValue }
        get { return _subTotal }
    }
    
    var total : Double {
        set { _total = newValue }
        get { return _total }
    }
    var dateOfDelivery : String {
        set { _dateOfDelivery = newValue }
        get { return _dateOfDelivery }
    }
    var distributionHour : DistributionHour? {
        set { _distributionHour = newValue }
        get { return _distributionHour }
    }
    
    var state : String {
        set { _state = newValue }
        get { return _state }
    }
    
    var dateToRecive : String {
        set { _dateToRecive = newValue }
        get { return _dateToRecive }
    }
    var dateRecive : String {
        set { _dateRecive = newValue }
        get { return _dateRecive }
    }
    var dateCancel : String {
        set { _dateCancel = newValue }
        get { return _dateCancel }
    }
    var deliveryCost : Double {
        set { _deliveryCost = newValue }
        get { return _deliveryCost }
    }
    var items : [ItemOrderDC] {
        set { _items = newValue }
        get { return _items }
    }
    var dateHourMaxAnulation : String {
        set { _dateHourMaxAnulation = newValue }
        get { return _dateHourMaxAnulation }
    }
    
    
    
}
