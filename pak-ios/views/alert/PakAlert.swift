//
//  PakAlert.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/25/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class PakAlert : UIViewController {


    @IBOutlet weak var tv_message: UITextView!
    @IBOutlet weak var nslc_inner_height: NSLayoutConstraint!
    @IBOutlet weak var nslc_outer_height: NSLayoutConstraint!
    
    var message : String? = nil

    
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
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func setElements() {
        self.tv_message.text = message
        let numLines = (self.tv_message.contentSize.height / (self.tv_message.font?.lineHeight)!)
        //Base 130 >> 160
        self.nslc_inner_height.constant = CGFloat(130 + 30*(numLines))
        self.nslc_outer_height.constant = CGFloat(160 + 30*(numLines))
    }

    
}
