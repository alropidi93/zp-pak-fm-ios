//
//  RoundedCornerViewGreen.swift
//  pak-ios
//
//  Created by inf227al on 19/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class RoundedCornerViewGreen: UIView
{
    @IBInspectable var rectWidth:   CGFloat = 60
    @IBInspectable var rectHeight:  CGFloat = 60
    
    @IBInspectable var rectBgColor:     UIColor = UIColor(rgb: 0xff5f5f)
    @IBInspectable var rectBorderColor: UIColor = UIColor(rgb: 0xff5f5f)
    @IBInspectable var rectBorderWidth: CGFloat = 0.5
    @IBInspectable var rectCornerRadius:CGFloat = 11
        {
        didSet { print("cornerRadius was set here")
            invalidateIntrinsicContentSize()
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        roundRect()
    }
    
    internal func roundRect()
    {
        let xf:CGFloat = (self.frame.width  - rectWidth)  / 2
        let yf:CGFloat = (self.frame.height - rectHeight) / 2
        
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        ctx.setLineWidth(rectBorderWidth)
        ctx.setStrokeColor(rectBorderColor.cgColor)
        
        
        let rectangle = CGRect(x: xf, y: yf, width: rectWidth, height: rectHeight)
        let header = CGRect(x: xf, y: yf, width: rectWidth, height: 0.3*rectHeight  )
        
        let clipPath: CGPath = UIBezierPath(roundedRect: header, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: rectCornerRadius, height: rectCornerRadius)).cgPath
        let linePath: CGPath = UIBezierPath(roundedRect: rectangle, cornerRadius: rectCornerRadius).cgPath
        let headerPath : CGPath = UIBezierPath(roundedRect: header, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: rectCornerRadius, height: rectCornerRadius)).cgPath
        
        
        ctx.addPath(clipPath)
        ctx.setFillColor(rectBgColor.cgColor)
        ctx.closePath()
        ctx.fillPath()
        
        
        
        ctx.addPath(linePath)
        ctx.addPath(headerPath)
        ctx.strokePath()
        
        ctx.restoreGState()
        
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
