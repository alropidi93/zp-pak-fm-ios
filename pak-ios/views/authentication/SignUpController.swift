//
//  SingupController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/24/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView
import RLBAlertsPickers


class SignUpController : UIViewController, NVActivityIndicatorViewable{
    
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_lastname: UITextField!
    @IBOutlet weak var tf_brithday: UITextField!
    @IBOutlet weak var tf_genre: UITextField!
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var tf_address: UITextField!
    @IBOutlet weak var tf_district: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_repassword: UITextField!
    private var date : Int = -1

    var districts : [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements (){
        fullKeyboardSupport()
        getDistrict()
        self.navigationController?.navigationBar.topItem?.title = "Registrarse en PAK"
        
        self.tf_genre.inputView = UIView()
        let tap_genre = UITapGestureRecognizer(target: self, action: #selector(self.tapGenre(_:)))
        self.tf_genre.addGestureRecognizer(tap_genre)
        
        self.tf_district.inputView = UIView()
        let tap_district = UITapGestureRecognizer(target: self, action: #selector(self.tapDistrict(_:)))
        self.tf_district.addGestureRecognizer(tap_district)
        
        self.tf_brithday.inputView = UIView()
        let tap_birtday = UITapGestureRecognizer(target: self, action: #selector(self.tapCalendar(_:)))
        self.tf_brithday.addGestureRecognizer(tap_birtday)
    }
    
    
    @objc func tapCalendar(_ sender: UITapGestureRecognizer) -> Void {
        
        let alert = UIAlertController(style: .actionSheet, title: "Distritos")
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: Date()) { date in
            self.date = UtilMethods.intFromDate(date)
            self.tf_brithday.text = UtilMethods.formatDate(date)
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
                }
            }
        }
        alert.addAction(title: "OK", style: .cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func tapGenre(_ sender: UITapGestureRecognizer) -> Void {
        let pickerData = [Constants.MALE,Constants.FEMALE]
        let alert = UIAlertController(style: .actionSheet, title: "Genero")
        let pickerViewValues: [[String]] = [pickerData]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) {vc , picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    self.tf_genre.text = pickerViewValues.item(at: index.column)?.item(at: index.row)
                }
            }
        }
        alert.addAction(title: "OK", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDistrict(){
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        Alamofire.request(URLs.ListDistrict, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    self.districts = []
                    for ( _ , element) in jsonResult["Distritos"] {
                        let district = DistrictDC(element)
                        self.districts.append(district.name)
                    }

                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlamoMethods.customError(message: jsonResult["message"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
    
    func register(){
        let params: Parameters = [
            "Nombres": self.tf_name.text!,
            "Apellidos": self.tf_lastname.text!,
            "Email": self.tf_email.text!,
            "Direccion": self.tf_address,
            "IdDistrito": self.tf_district,
            "Telefono": self.tf_phone,
            "Password": self.tf_password,
            "RepetirPassword": self.tf_repassword,
//            "FacebookID": ,
//            "GoogleID": ,
//            "GUID": ,
            ]
        
    }
    
    
}
