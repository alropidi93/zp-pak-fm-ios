//
//  UIViewExtension.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/11/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}

extension Int64 {
    var unsigned: UInt64 {
        let valuePointer = UnsafeMutablePointer<Int64>.allocate(capacity: 1)
        defer {
            valuePointer.deallocate()
        }
        
        valuePointer.pointee = self
        
        return valuePointer.withMemoryRebound(to: UInt64.self, capacity: 1) { $0.pointee }
    }
}

extension UInt64 {
    var signed: Int64 {
        let valuePointer = UnsafeMutablePointer<UInt64>.allocate(capacity: 1)
        defer {
            valuePointer.deallocate()
        }
        
        valuePointer.pointee = self
        
        return valuePointer.withMemoryRebound(to: Int64.self, capacity: 1) { $0.pointee }
    }
}



private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    func trim() -> String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func matches(regEx: String) -> Bool {
        return NSPredicate(format: "self MATCHES [c] %@", regEx).evaluate(with: self)
    }
    
    func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
            }.joined(separator: separator))
    }
}

