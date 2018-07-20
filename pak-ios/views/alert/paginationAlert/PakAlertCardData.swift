//
//  PakAlertCardData.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/3/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
class PakAlertCardData : UIViewController, PageObservation{
    var parentPageViewController: AlertPageVc!
    
    @IBOutlet weak var tf_titular: UITextField!
    @IBOutlet weak var tf_card_number: UITextField!
    @IBOutlet weak var tf_expired_date: UITextField!
    @IBOutlet weak var tf_ccv: UITextField!
    
    var date = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        tf_titular.addTarget(self, action: #selector(textfieldDidChangeTitular), for: .editingChanged)
        tf_card_number.addTarget(self, action: #selector(textfieldDidChangecard_number), for: .editingChanged)
        
        self.tf_expired_date.inputView = UIView()
        self.tf_expired_date.setBottomBorder()
        let tap_date = UITapGestureRecognizer(target: self, action: #selector(self.tapDate(_:)))
        self.tf_expired_date.addGestureRecognizer(tap_date)
        
        tf_ccv.addTarget(self, action: #selector(textfieldDidChangeccv), for: .editingChanged)
    }
    
    @objc func textfieldDidChangeTitular(sender: UITextField!) {
        parentPageViewController.titular = sender.text!
    }
    
    @objc func textfieldDidChangecard_number(sender: UITextField!) {
        parentPageViewController.numTarjeta = sender.text!
    }
    
    @objc func tapDate(_ sender: UITapGestureRecognizer) -> Void {
        let alert = UIAlertController(style: .actionSheet, title: "Fecha")
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: Date().tomorrow , maximumDate: nil ) { date in
            
            self.date = UtilMethods.intFromDate(date)
            self.tf_expired_date.text = UtilMethods.formatDateMY(date)
            self.parentPageViewController.expiredDateMM = UtilMethods.DateToString(UtilMethods.formatDateMY(date).components(separatedBy: "-")[0])
            self.parentPageViewController.expiredDateYYYY = UtilMethods.formatDateMY(date).components(separatedBy: "-")[1]
        }
        alert.addAction(image: nil, title: "OK", style: .cancel, isEnabled: true, handler: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textfieldDidChangeccv(sender: UITextField!) {
        parentPageViewController.ccv = sender.text!
    }
    
    @IBAction func b_close(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getParentPageViewController(parentRef: AlertPageVc) {
        parentPageViewController = parentRef
    }
    
    
}

