//
//  PakLoader.swift
//  pak-ios
//
//  Created by Andres Moreno on 8/11/18.
//  Copyright © 2018 amd. All rights reserved.
//


import Foundation
import UIKit

public class PakLoader {
    
    // Ojo: Si existe una barra superior (top bar) sin transparencia, el espacio podria estar reservado y separado del View principal
    
    static var currentOverlay : UIView?
    static var image = UIImageView(image: #imageLiteral(resourceName: "dwb_ic_box")) // Imagen central
    
    
    // El loader cargara sobre la vista de la ventana principal
    static func show(){
        guard let currentMainWindow = UIApplication.shared.keyWindow else {
            print("No main window.")
            return
        }
        show(currentMainWindow)
    }
    
    // El loader cargara sobre el UIView que se ponga en el constructor
    static func show(_ overlayTarget : UIView){
        hide()
        // Create and center overlay into overlayTarget
        let overlay = UIView(frame: overlayTarget.frame)
        overlay.center = overlayTarget.center
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.black
        overlayTarget.addSubview(overlay)
        overlayTarget.bringSubview(toFront: overlay)
        
        // Center image into overlayTarget
        image.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        image.alpha = 0
        image.contentMode = .scaleAspectFit
        image.center = overlayTarget.center
        overlayTarget.addSubview(image)
        overlayTarget.bringSubview(toFront: image)
        
        currentOverlay = overlay
        
        //Start Animation
        fadeIn()
        
    }
    static func fadeIn(){
        UIView.animate(withDuration: 0.15, animations: {
            currentOverlay?.alpha = 0.8
            image.alpha = 1
        }, completion: { (finished: Bool) in
            rotateImageRight()
        })
    }
    
    static func rotateImageRight(){
        if currentOverlay != nil {
            UIView.animate(withDuration: 0.05, delay: 0.3 , animations: {
                image.transform = CGAffineTransform(rotationAngle: CGFloat(10 * .pi / 180.0))
            }, completion: { (finished: Bool) in
                rotateImageLeft()
            })
        }
    }
    
    static func rotateImageLeft(){
        if currentOverlay != nil {
            UIView.animate(withDuration: 0.05, delay: 0.1, animations: {
                image.transform = CGAffineTransform(rotationAngle: CGFloat(-10 * .pi / 180.0))
            }, completion: { (finished: Bool) in
                rotateImageCenter()
            })
        }
    }
    
    static func rotateImageCenter(){
        if currentOverlay != nil {
            UIView.animate(withDuration: 0.05, delay: 0.1, animations: {
                image.transform = CGAffineTransform(rotationAngle: CGFloat(0 * .pi / 180.0))
            }, completion: { (finished: Bool) in
                rotateImageRight()
            })
        }
    }
    
    static func hide() {
        if currentOverlay != nil {
            UIView.animate(withDuration: 0.15, delay: 0, animations: {
                image.alpha = 0
                currentOverlay?.alpha = 0
            }, completion: { (finished: Bool) in
                currentOverlay?.removeFromSuperview()
                currentOverlay =  nil
                image.removeFromSuperview()
            })
        }
    }
}
