//
//  PakAlertvFacturation.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/3/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
class PakAlertFacturacion : UIViewController,PageObservation,UITextFieldDelegate{
    @IBOutlet weak var dwb_pak_factura: UIImageView!
    @IBOutlet weak var sv_facture_data: UIStackView!
    @IBOutlet weak var tf_announcement_fac: UITextView!
    @IBOutlet weak var tf_ruc: UITextField!
    @IBOutlet weak var tf_socialRazon: UITextField!
    @IBOutlet weak var tf_fiscal_direcction: UITextField!
    @IBOutlet weak var tf_announcment_bol: UITextView!
    @IBOutlet weak var dwb_pak_boleta: UIImageView!
    
    var parentPageViewController: AlertPageVc!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
       setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setElements() {
        tf_ruc.addTarget(self, action: #selector(textfieldDidChangeRuc), for: .editingChanged)
        self.tf_ruc.delegate = self
        tf_socialRazon.addTarget(self, action: #selector(textfieldDidChangesocialRazon), for: .editingChanged)
        tf_fiscal_direcction.addTarget(self, action: #selector(textfieldDidChangefiscal_direcction), for: .editingChanged)
    }
    
    @objc func textfieldDidChangeRuc(sender: UITextField!) {
        parentPageViewController.checkOut.ruc = sender.text!
    }
    
    @objc func textfieldDidChangesocialRazon(sender: UITextField!) {
        parentPageViewController.checkOut.businessName = sender.text!
    }
    
    @objc func textfieldDidChangefiscal_direcction(sender: UITextField!) {
        parentPageViewController.checkOut.fiscalAddress = sender.text!
    }
    
    func getParentPageViewController(parentRef: AlertPageVc) {
        parentPageViewController = parentRef
    }
    
    @IBAction func b_factura(_ sender: Any) {
        parentPageViewController.boletaOrFactura = 1
        self.hideMenuBolOFact()
        print("factura")
    }
    
    
    @IBAction func b_back(_ sender: Any) {
        parentPageViewController.goBackPage()
        
    }
    
    
    @IBAction func b_bolata(_ sender: Any) {
        parentPageViewController.boletaOrFactura = 0
        self.hideMenuBolOFact()
        print("boleta")
    }
    
    func hideMenuBolOFact() {
        if  parentPageViewController.boletaOrFactura == 1 {
            tf_announcment_bol.isHidden = true
            dwb_pak_boleta.isHidden = true
            tf_announcement_fac.isHidden = false
            dwb_pak_factura.isHidden = false
            sv_facture_data.isHidden = false
        } else if  parentPageViewController.boletaOrFactura == 0 {
            tf_announcment_bol.isHidden = false
            dwb_pak_boleta.isHidden = false
            tf_announcement_fac.isHidden = true
            dwb_pak_factura.isHidden = true
            sv_facture_data.isHidden = true
        }
    }

    @IBAction func b_close(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
