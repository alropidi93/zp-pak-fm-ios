//
//  AlertViewPayment.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/6/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
class AlertViewPayment : UIViewController ,NVActivityIndicatorViewable {
    @IBOutlet weak var b_next: UIButton!
    @IBOutlet weak var uv_pv_payments: UIView!
    var finishBoxDelegate : FinishBoxDelegate? = nil

    var page : Int = -1
    var dataDelivery : DataDeliveryDC? = nil

    private var embeddedViewController : AlertPageVc!
    
    @IBAction func b_next(_ sender: Any) {
        self.page = self.embeddedViewController.pageNow
        self.embeddedViewController.goNextPage(forwardTo: page)
        if page == 4 {
            b_next.setTitle("Pagar", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setElements()
    }
    
    func setElements() {
        self.embeddedViewController.finishBoxDelegate = self.finishBoxDelegate
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
