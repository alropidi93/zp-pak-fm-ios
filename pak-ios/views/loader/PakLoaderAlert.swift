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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    
    func stopLoader()
    {
        
    }
    
    
    
}
