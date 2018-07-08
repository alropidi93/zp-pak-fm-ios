//
//  DistributionHour.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVKit
class DistributionHour : NSObject {
    private var _idDistribution : String = ""
    private var _iniHour : String = ""
    private var _endHour : String = ""
    private var _maxCount : Int64 = 0
    
    override init() {
    }
    
    init(_ jsonDistributionHour: JSON){
        super.init()
        self._idDistribution = jsonDistributionHour["ID"].string ?? self._idDistribution
        self._iniHour = jsonDistributionHour["HoraInicio"].string ?? self._iniHour
        self._endHour = jsonDistributionHour["HoraFin"].string ?? self._endHour
        self._maxCount = jsonDistributionHour["CantidadMaxima"].int64 ?? self._maxCount
    }
    
    var idDistribution : String {
        set { _idDistribution = newValue }
        get { return _idDistribution }
    }
    
    var iniHour : String {
        set { _iniHour = newValue }
        get { return _iniHour }
    }
    
    var endHour : String {
        set { _endHour = newValue }
        get { return _endHour }
    }
    
    var maxCount : Int64 {
        set { _maxCount = newValue }
        get { return _maxCount }
    }
}
