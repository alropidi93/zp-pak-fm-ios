//
//  DataDeliveryDc.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVKit

class DataDeliveryDC  : NSObject {
    private var _district : [DistrictDC] = []
    private var _hours : [DistributionHour] = []
    private var _hoursString : [String] = []
    private var _deliveryCost : Double = 0.0
    private var _minAmount : Double = 0.0
    private var _timeMaxAnulation : Int64 = 0
    
    
    // Utility extras
    override init() {
    }
    
    init(_ jsonDataDelivery: JSON){
        super.init()
        for (_, subJson) in jsonDataDelivery["Distritos"]{
            let _item = DistrictDC(subJson);
            self._district.append(_item)
        }
        for (_, subJson) in jsonDataDelivery["HorariosReparto"]{
            let _item = DistributionHour(subJson);
            self._hours.append(_item)
        }
        self._deliveryCost = jsonDataDelivery["Distritos"].double ?? self._deliveryCost
        self._minAmount = jsonDataDelivery["Nombre"].double ?? self._minAmount
        self._timeMaxAnulation = jsonDataDelivery["Orden"].int64 ?? self._timeMaxAnulation
    }
    
    var district : [DistrictDC] {
        set { _district = newValue }
        get { return _district }
    }
    
    var hoursString : [String] {
        set { _hoursString = newValue }
        get { return _hoursString }
    }
    
    var hours : [DistributionHour] {
        set { _hours = newValue }
        get { return _hours }
    }
    
    var deliveryCost : Double {
        set { _deliveryCost = newValue }
        get { return _deliveryCost }
    }

    var minAmount : Double {
        set { _minAmount = newValue }
        get { return _minAmount }
    }
    
    var timeMaxAnulation : Int64 {
        set { _timeMaxAnulation = newValue }
        get { return _timeMaxAnulation }
    }
}
