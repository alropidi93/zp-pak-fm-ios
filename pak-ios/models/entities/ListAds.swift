//
//  ListAds.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/4/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON

class ListAds  : NSObject {
    private var _listAds: [Ads] = []
    
    override init() {
    }
    
    init(_ jsonListAds: JSON) {
        super.init()
        for (_, subJson) in jsonListAds["Anuncios"]{
            let _Ad = Ads(subJson);
            self._listAds.append(_Ad)
        }
    }
   
    var getAds : [Ads] {
        set { _listAds = newValue }
        get { return _listAds }
    }
}
