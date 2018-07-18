//
//  PakAlertCustomReady.swift
//  pak-ios
//
//  Created by inf227al on 16/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
class PakAlertCustomReady : UIViewController {
    
    @IBOutlet var tv_message: UITextView!
    
    @IBOutlet var tv_title: UILabel!
    
    var message : String? = nil
    var title_message : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setElements(){
        self.tv_title.text = title_message
        self.tv_message.text = message
    }
    @IBAction func b_accept(_ sender: Any) {
         self.dismiss(animated: false, completion: nil)
    }
    
}
