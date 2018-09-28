//
//  Ads.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/4/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVKit

class Ads: NSObject {
    // Core definition
    private var _idAd: Int64 = 0
    private var _type: String = ""
    private var _archive : String = ""
    
    // Utility extras
    private var _thumbnail : UIImage? = nil
    private var _asset : AVAssetImageGenerator?
    
    override init() {
    }
    
    init(_ jsonAds: JSON) {
        super.init()
        self._idAd = jsonAds["IdAnuncio"].int64 ?? self._idAd
       
        self._type = jsonAds["Tipo"].string ?? self._type
        self._archive = jsonAds["Archivo"].string ?? self._archive
        
        if self.type == "V" { // Videos
            
            let url = URL(string:"\(self.archive)")!
            let asset = AVAsset(url: url)
            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            self._asset = assetImgGenerate
            /*
            let time = CMTimeMake(2, 1)
            let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            if img == nil {
                self._thumbnail = UIImage(named: "")
            } else {
                self._thumbnail  = UIImage(cgImage: img!)
            }*/
        }
    }
    
    var idAd : Int64 {
        set { _idAd = newValue }
        get { return _idAd }
    }
    
    
    var type : String {
        set { _type = newValue }
        get { return _type }
    }
    
    var archive : String {
        set { _archive = newValue }
        get { return URLs.MultimediaAnuncioURL + _archive }
    }
    
    var thumbnail : UIImage? {
        get { return _thumbnail }
    }
    
    var asset : AVAssetImageGenerator? {
        get { return _asset }
    }
}
