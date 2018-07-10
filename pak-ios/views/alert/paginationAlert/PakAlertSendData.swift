//
//  PakAlertSendData.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/3/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView
import RLBAlertsPickers
import SwiftHash

class PakAlertSendData : UIViewController, PageObservation , NVActivityIndicatorViewable{
    var parentPageViewController: AlertPageVc!

    @IBOutlet weak var tf_direction: UITextField!
    @IBOutlet weak var tf_district: UITextField!
    @IBOutlet weak var tf_reference: UITextField!
    @IBOutlet weak var tf_data_reciver: UITextField!
    @IBOutlet weak var tf_date: UITextField!
    @IBOutlet weak var tf_hours: UITextField!
    
    var checkOut : CheckOut? = nil
    private var posDistrict: Int = -1
    
    var districts : [String] = []
    var listDistrict : [DistrictDC] = []
    
    var hours : [String] = []
    var district : [String] = []
    var varHours: [String] = []

    var date = -1
    @IBAction func b_dismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setElements() {
        fullKeyboardSupport()
        getDataDelivery()
        tf_data_reciver.text = ConstantsModels.static_user?.names
        self.tf_district.inputView = UIView()
        let tap_district = UITapGestureRecognizer(target: self, action: #selector(self.tapDistrict(_:)))
        self.tf_district.addGestureRecognizer(tap_district)
        
        self.tf_hours.inputView = UIView()
        self.tf_hours.setBottomBorder()
        let tap_hours = UITapGestureRecognizer(target: self, action: #selector(self.tapHours(_:)))
        self.tf_hours.addGestureRecognizer(tap_hours)
        
        self.tf_date.inputView = UIView()
        self.tf_date.setBottomBorder()
        let tap_date = UITapGestureRecognizer(target: self, action: #selector(self.tapDate(_:)))
        self.tf_date.addGestureRecognizer(tap_date)
        
        tf_direction.addTarget(self, action: #selector(textfieldDidChangedirection), for: .editingChanged)
        tf_reference.addTarget(self, action: #selector(textfieldDidChangereference), for: .editingChanged)
        tf_data_reciver.addTarget(self, action: #selector(textfieldDidChangereciver), for: .editingChanged)
    }
    
    @objc func textfieldDidChangedirection(sender: UITextField!) {
        parentPageViewController.checkOut.address = sender.text!
    }
    
    @objc func textfieldDidChangereference(sender: UITextField!) {
        parentPageViewController.checkOut.reference = sender.text!
    }
    
    @objc func textfieldDidChangereciver(sender: UITextField!) {
        parentPageViewController.checkOut.recipentName = sender.text!
    }

    @objc func tapHours(_ sender: UITapGestureRecognizer) -> Void {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "America/Lima")!
        
        let hour = calendar.component(.hour, from: Date())

        print(hour)
        var hours : [String] = []
        if tf_date.text != "" {
            if hour > 18 && tf_date.text == Date().tomorrow.toString(dateFormat: "dd-MMM-yyyy") {
                let elem = self.parentPageViewController.dataDelivery?.hours[2]
                varHours.append("N")
                let distributionHour  = (elem?.iniHour)! + " - " + (elem?.endHour)!
                hours.append(distributionHour)
            } else {
                for elem in (self.parentPageViewController.dataDelivery?.hours)! {
                    let distributionHour  = elem.iniHour + " - " + elem.endHour
                    hours.append(distributionHour)
                }
                self.varHours.append("D")
                self.varHours.append("T")
                self.varHours.append("N")
            }
        }else {
            return
        }
        
        let alert = UIAlertController(style: .actionSheet, title: "Horas")
        let pickerViewValues: [[String]] = [hours]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) {vc , picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    self.tf_hours.text = pickerViewValues.item(at: index.column)?.item(at: index.row)
                    self.parentPageViewController.checkOut.hourlySale = self.varHours[index.row]
                    
                }
            }
        }
        alert.addAction(title: "OK", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapDate(_ sender: UITapGestureRecognizer) -> Void {
        let alert = UIAlertController(style: .actionSheet, title: "Fecha")
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: Date().tomorrow , maximumDate: Date().nextMonth ) { date in
            self.date = UtilMethods.intFromDate(date)
            self.tf_date.text = UtilMethods.formatDate(date)
            self.parentPageViewController.checkOut.date = date.toString(dateFormat: "dd/MM/YYYY")
        }
        alert.addAction(image: nil, title: "OK", style: .cancel, isEnabled: true, handler: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapDistrict(_ sender: UITapGestureRecognizer) -> Void {
        let alert = UIAlertController(style: .actionSheet, title: "Distritos")
        let pickerViewValues: [[String]] = [districts]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) {vc , picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    self.tf_district.text = pickerViewValues.item(at: index.column)?.item(at: index.row)
                    self.parentPageViewController.checkOut.district = Int64(self.listDistrict[index.row].idDistrict)
                }
            }
        }
        alert.addAction(title: "OK", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
   
    func getParentPageViewController(parentRef: AlertPageVc) {
        parentPageViewController = parentRef
    }
    
    func getDataDelivery() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        let params: Parameters = ["GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID ]
        print(PreferencesMethods.getSmallBoxFromOptions()!.GUID)
        Alamofire.request(URLs.DataDelivery, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Data"] == true {
                        let dataDelivery  = DataDeliveryDC(jsonResult)
                        for district in dataDelivery.district{
                            self.districts.append(district.name)
                            self.listDistrict.append(district)
                        }
                        
                    }else{
                        let jsonResult = JSON(jsonResponse)
                        print(jsonResult["MontoMinimo"])
                        AlarmMethods.errorWarning(message: "El monto mínimo para el pedido es de S/ " + jsonResult["MontoMinimo"].stringValue + " (sin incluir costo de delivery).", uiViewController: self)
                    }
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
    
    
    
}
