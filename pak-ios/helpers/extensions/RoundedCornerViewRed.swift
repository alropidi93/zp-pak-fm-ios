//
//  RoundedCornerViewRed.swift
//  pak-ios
//
//  Created by Paolo Rossi on 7/20/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class RoundedCornerViewRed: UIView
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


