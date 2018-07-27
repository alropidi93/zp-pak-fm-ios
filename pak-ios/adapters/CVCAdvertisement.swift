//
//  TVCAds.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/4/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class CVCAdvertisement : UICollectionViewCell {
    @IBOutlet weak var iv_advertisement: UIImageView!
    
    @IBOutlet weak var iv_play: UIImageView!
    var advertisement_image : UIImageView? {
        get { return iv_advertisement }
    }
}
