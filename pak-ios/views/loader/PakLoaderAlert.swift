//
//  PakLoaderAlert.swift
//  pak-ios
//
//  Created by inf227adm on 19/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class PakLoaderAlert : UIViewController {

 
   
    @IBOutlet weak var iv_loader_image: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.iv_loader_image.transform = CGAffineTransform(rotationAngle: (-45))
            
        }){_ in
            UIView.animateKeyframes(withDuration: 1.0, delay: 0.25, options: [.autoreverse, .repeat], animations: {
                self.iv_loader_image.transform = CGAffineTransform(rotationAngle: (45))
            })}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    
    func stopLoader()
    {
        UIView.animateKeyframes(withDuration: <#T##TimeInterval#>, delay: <#T##TimeInterval#>, options: <#T##UIViewKeyframeAnimationOptions#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        self.dismiss(animated: true, completion: nil)

    }
    
    
    
}
