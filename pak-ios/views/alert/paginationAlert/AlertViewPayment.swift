//
//  AlertViewPayment.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/6/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//


import Foundation
import UIKit

class AlertViewPayment : UIViewController {
    
    @IBOutlet weak var uv_pv_payments: UIView!
    var dataDelivery : DataDeliveryDC? = nil
    private var embeddedViewController : AlertPageVc!
    
    
    @IBAction func b_next(_ sender: Any) {
        print(Calendar.current.component(.hour, from: Date()))
        self.embeddedViewController.goNextPage(forwardTo: 1)
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setElements()
        
    }
    func setElements(){
        self.embeddedViewController.dataDelivery = self.dataDelivery
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let vc = segue.destination as? AlertPageVc,
                segue.identifier == "segue_embed_page_vc" {
            self.embeddedViewController = vc
        }
    }
    
}
