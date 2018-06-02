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
import SwiftHash

class SignUpController : UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_lastname: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_genre: UITextField!
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var tf_address: UITextField!
    @IBOutlet weak var tf_district: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_repassword: UITextField!
    
    private var date : Int = -1
    private var posDistrict: Int = -1

    let segue_identifier = "segue_register_main"
    
    var districts : [String] = []
    var listDistrict : [DistrictDC] = []
    
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
        
        self.tf_genre.inputView = UIView()
        let tap_genre = UITapGestureRecognizer(target: self, action: #selector(self.tapGenre(_:)))
        self.tf_genre.addGestureRecognizer(tap_genre)
        
        self.tf_district.inputView = UIView()
        let tap_district = UITapGestureRecognizer(target: self, action: #selector(self.tapDistrict(_:)))
        self.tf_district.addGestureRecognizer(tap_district)
        
        self.tf_birthday.inputView = UIView()
        let tap_birtday = UITapGestureRecognizer(target: self, action: #selector(self.tapCalendar(_:)))
        self.tf_birthday.addGestureRecognizer(tap_birtday)
    }
    
    
    @objc func tapCalendar(_ sender: UITapGestureRecognizer) -> Void {
        
        let alert = UIAlertController(style: .actionSheet, title: "Distritos")
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: Date()) { date in
            self.date = UtilMethods.intFromDate(date)
            self.tf_birthday.text = UtilMethods.formatDate(date)
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
                    self.posDistrict = index.row
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
                        self.listDistrict.append(DistrictDC(element))
                    }

                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlamoMethods.customError(message: jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
    @IBAction func signUp(_ sender: Any) {
        if (self.tf_name.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El nombre no puede estar vacío", uiViewController: self)
            return
        } else if self.tf_name.text?.count > 50 {
            AlarmMethods.errorWarning(message: "El nombre no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        }

        if (self.tf_lastname.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El apellido no puede estar vacío", uiViewController: self)
            return
        } else if self.tf_lastname.text?.count > 50 {
            AlarmMethods.errorWarning(message: "El apellido no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        }

        if (self.tf_email.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El email no puede estar vacío", uiViewController: self)
            return
        } else if self.tf_email.text?.count > 50 {
            AlarmMethods.errorWarning(message: "El email no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        }

        if (self.tf_address.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "La dirección no puede estar vacío", uiViewController: self)
            return
        } else if self.tf_address.text?.count > 50 {
            AlarmMethods.errorWarning(message: "La dirección no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        }

        if (self.tf_district.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El distrito no puede estar vacío", uiViewController: self)
            return
        } else if self.tf_district.text?.count > 50 {
            AlarmMethods.errorWarning(message: "El distrito no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        }

        if (self.tf_phone.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El teléfono no puede estar vacío", uiViewController: self)
            return
        } else if self.tf_phone.text?.count > 40 {
            AlarmMethods.errorWarning(message: "El teléfono no puede tener una extensión mayor a 40 caracteres", uiViewController: self)
            return
        } else if self.tf_phone.text?.count < 7 {
            AlarmMethods.errorWarning(message: "El teléfono no puede tener una extensión menor a 7 caracteres", uiViewController: self)
            return
        }

        if (self.tf_password.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "La contraseña no puede estar vacía", uiViewController: self)
            return
        } else if self.tf_password.text?.count > 50 {
            AlarmMethods.errorWarning(message: "La contraseña no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        }

        if (self.tf_repassword.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "La contraseña no puede estar vacía", uiViewController: self)
            return
        } else if self.tf_repassword.text?.count > 50 {
            AlarmMethods.errorWarning(message: "La contraseña no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        }

        if (self.tf_genre.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El sexo no puede estar vacía", uiViewController: self)
            return
        } else if self.tf_genre.text?.count > 50 {
            AlarmMethods.errorWarning(message: "El sexo  no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        }

        if (self.tf_birthday.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El cumpleaños no puede estar vacío", uiViewController: self)
            return
        } else if self.tf_birthday.text?.count > 30 {
            AlarmMethods.errorWarning(message: "El cumpleaños no puede tener una extensión mayor a 30 caracteres", uiViewController: self)
            return
        }
        if( self.tf_password.text! != self.tf_repassword.text!){
            AlarmMethods.errorWarning(message: "los passwords son diferentes", uiViewController: self)
            return
        }

        
        
        self.register((PreferencesMethods.getSmallBoxFromOptions()!.GUID))

    }

    
    func register(_ GUID: String){
        var genre : String = "-"
        if self.tf_genre.text! == "Masculino"  { genre = "M" } else { genre = "F" }
        
        let params: Parameters = [
            "Nombres": self.tf_name.text!,
            "Apellidos": self.tf_lastname.text!,
            "Email": self.tf_email.text!,
            "Direccion": self.tf_address.text!,
            "IdDistrito": self.listDistrict[self.posDistrict].idDistrict,
            "Telefono": self.tf_phone.text!,
            "Password": MD5(self.tf_password.text!),
            "RepetirPassword": MD5(self.tf_repassword.text!),
            "Sexo": genre,
            "FechaNacimiento":UtilMethods.dateToSlash(self.tf_birthday.text!),
            "GUID" : GUID,
            ]
    
        Alamofire.request(URLs.SignUp, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if !(response.response != nil) {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        let userDC : UserDC = UserDC(jsonResult)
                        userDC.valid = true
                        print(jsonResult["CodigoInvitacion"])
                        PreferencesMethods.saveUserToOptions(userDC)
                        self.stopAnimating()
                        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
                    }else {
                        self.stopAnimating()
                        if let jsonResponse = response.result.value {
                            let jsonResult = JSON(jsonResponse)
                            AlamoMethods.customError(message: jsonResult["Msg"].string!, uiViewController: self)
                        } else {
                            AlamoMethods.defaultError(self)
                        }
                    }
                }
            } else {
                self.stopAnimating()
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlamoMethods.customError(message: jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
        }
        
    }
    
    
}
