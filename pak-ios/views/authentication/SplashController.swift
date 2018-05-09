//
//  SplashController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import UIKit

class SplashController: UIViewController {
    private let segue_identifier = "segue_splash_login"
    private let logged_identifier = "segue_splash_main"
    
    @IBOutlet weak var iv_logo: UIImageView!
    
    var images: [UIImage] = [UIImage(named: "dwb_pak_menu_button")!, UIImage(named: "dwb_pak_logo")!, UIImage(named: "dwb_pak_menu_button")!, UIImage(named: "dwb_pak_logo")!, UIImage(named: "dwb_pak_menu_button")!, UIImage(named: "dwb_pak_logo")!, UIImage(named: "dwb_pak_menu_button")!, UIImage(named: "dwb_pak_logo")!]
    
    var animatedImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animatedImage = UIImage.animatedImage(with: images, duration: 10.0)
        self.iv_logo.image = self.animatedImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OperationQueue.main.addOperation {
            [weak self] in
            let user = UserMethods.getUserFromOptions()
            if user != nil && user?.valid == true {
                self?.performSegue(withIdentifier: (self?.logged_identifier)!, sender: self)
            } else {
                self?.performSegue(withIdentifier: (self?.segue_identifier)!, sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
