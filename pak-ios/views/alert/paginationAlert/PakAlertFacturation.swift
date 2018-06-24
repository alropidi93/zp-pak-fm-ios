//
//  PakAlertvFacturation.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/3/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
class PakAlertFacturacion : UIViewController,PageObservation{

   
    var parentPageViewController: AlertPageVc!
    
    
    
    @IBOutlet weak var dwb_pak_factura: UIImageView!
    @IBOutlet weak var sv_facture_data: UIStackView!
    @IBOutlet weak var tf_ruc: UIView!
    @IBOutlet weak var tf_social_reason: UIView!
    @IBOutlet weak var tf_address: UIView!
    
    @IBOutlet weak var tf_announcement: UITextView!
    @IBOutlet weak var dwb_pak_boleta: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
    func getParentPageViewController(parentRef: AlertPageVc) {
        parentPageViewController = parentRef
    }
    
    @IBAction func b_factura(_ sender: Any) {
        parentPageViewController.boletaOrFactura = 1
        print("factura")
    }
    @IBAction func b_bolata(_ sender: Any) {
        parentPageViewController.boletaOrFactura = 0

        print("boleta")

    }

    @IBAction func b_close(_ sender: Any) {
    }
}

