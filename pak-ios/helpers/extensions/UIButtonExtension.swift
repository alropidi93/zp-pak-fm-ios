//
//  UIButtonExtension.swift
//  pak-ios
//
//  Created by Alvaro on 8/7/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import UIKit

extension UIButton {
    func preventRepeatedPresses(inNext seconds: Double = 5) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }
}
