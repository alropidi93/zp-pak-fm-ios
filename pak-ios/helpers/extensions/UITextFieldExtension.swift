//
//  UITextField.swift
//  pak-ios
//
//  Created by Paolo Rossi on 7/7/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func clearBottomBorder(){
        self.borderStyle = .none
    }
}
