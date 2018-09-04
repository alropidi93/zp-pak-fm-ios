//
//  PakAlertCodeInvitation.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/28/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class PakAlertCodeInvitation: UIViewController  {
    @IBOutlet weak var tf_code_invitation: UITextField!
    @IBOutlet weak var nslc_outer_height: NSLayoutConstraint!
    @IBOutlet weak var nslc_inner_height: NSLayoutConstraint!
    
    var codeInvitationDelegate : AlertCodeInvitationDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    @IBAction func ba_accept(_ sender: Any) {
        codeInvitationDelegate?.okButtonTapped(self.tf_code_invitation.text!)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func ba_close(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func setElements() {
        let numLines = 1
        //Base 130 >> 160
        self.nslc_inner_height.constant = CGFloat(130 + 30*(numLines))
        self.nslc_outer_height.constant = CGFloat(160 + 30*(numLines))
    }
}

