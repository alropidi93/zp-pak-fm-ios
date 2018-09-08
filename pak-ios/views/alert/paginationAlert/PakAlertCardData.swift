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
    
    let datePicker = UIDatePicker()

    var date = -1
    
    var pickerDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        //showDatePicker()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        tf_titular.addTarget(self, action: #selector(textfieldDidChangeTitular), for: .editingChanged)
        tf_card_number.addTarget(self, action: #selector(textfieldDidChangecard_number), for: .editingChanged)
        
        self.tf_expired_date.inputView = UIView()
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
    
    @IBAction func b_back(_ sender: Any) {
        parentPageViewController.goBackPage()

    }
    
    
    @objc func tapDate(_ sender: UITapGestureRecognizer) -> Void {
        let alert = UIAlertController(style: .alert, title: "Fecha")
        alert.addDatePicker(mode: .date, date: pickerDate, minimumDate: Date().tomorrow , maximumDate: nil ) { date in
            self.date = UtilMethods.intFromDate(date)
            self.tf_expired_date.text = UtilMethods.formatDateMY(date)
            self.parentPageViewController.expiredDateMM = date.toString(dateFormat: "MM")
            self.parentPageViewController.expiredDateYYYY = date.toString(dateFormat: "yyyy")
            self.pickerDate = date
        }
        alert.addAction(image: nil, title: "OK", style: .cancel, isEnabled: true, handler: {(action:UIAlertAction!) in
            print("okAction")
            //amd
            self.date = UtilMethods.intFromDate(self.pickerDate)
            self.tf_expired_date.text = UtilMethods.formatDateMY(self.pickerDate)
            self.parentPageViewController.expiredDateMM = self.pickerDate.toString(dateFormat: "MM")
            self.parentPageViewController.expiredDateYYYY = self.pickerDate.toString(dateFormat: "yyyy")
            //...
        })
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
    /*
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        tf_expired_date.inputAccessoryView = toolbar
        tf_expired_date.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        tf_expired_date.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }*/
}
    


