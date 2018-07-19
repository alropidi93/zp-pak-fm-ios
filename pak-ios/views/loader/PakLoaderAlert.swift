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
        iv_loader_image.transform = CGAffineTransform(rotationAngle: <#T##CGFloat#>)
       
        self.iv_loader_image.animationRepeatCount = 1
        self.iv_loader_image.animationDuration = 1.0
        self.iv_loader_image.startAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    
    func stopLoader()
    {
        self.dismiss(animated: false, completion: nil)

    }
    
    
    
}
