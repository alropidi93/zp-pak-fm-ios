//
//  EditController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/12/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView
import RLBAlertsPickers
import SwiftHash

class EditController : UIViewController,NVActivityIndicatorViewable,UITextFieldDelegate{
    
    
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_lastname: UITextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_genre: UITextField!
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var tf_address: UITextField!
    @IBOutlet weak var tf_district: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    
    private var date : Int = -1
    private var posDistrict: Int = -1
    //amd
    private var colGenre: Int = 0
    private var rowGenre: Int = 0
    private var genre = "X"
    private var pickerDate = Date.init()
    //...
    
    private var idDistric : UInt64  = 0
    private var cont : Int = 0
    var districts : [String] = []
    var listDistrict : [DistrictDC] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setElements()
        //amd
        if ConstantsModels.static_user?.genere == "M" {
            genre = "M"
        }else if ConstantsModels.static_user?.genere == "F" {
            genre = "F"
        }else if ConstantsModels.static_user?.genere == "X" {
            genre = "X"
        }
        //aqui trate de setear la fecha default del picker con la de nacimiento pero me dice es nulo
        self.pickerDate = UtilMethods.stringToDateAmd((ConstantsModels.static_user?.birthDate)!)
        //...
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements(){
        self.cont = 0
        setInfoUser()
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
        self.tf_phone.delegate = self
    }
    func setInfoUser(){
        tf_name.text = ConstantsModels.static_user?.names
        tf_lastname.text = ConstantsModels.static_user?.lastNames
        tf_birthday.text = ConstantsModels.static_user?.birthDate
        //tf_genre.text = ConstantsModels.static_user?.genere
        if ConstantsModels.static_user?.genere == "M"  {
            self.tf_genre.text = "Masculino"
        }else if ConstantsModels.static_user?.genere == "F"  {
            self.tf_genre.text = "Femenino"
        }else if ConstantsModels.static_user?.genere == "X"  {
            self.tf_genre.text = Constants.X
        }
        tf_phone.text = ConstantsModels.static_user?.telephone
        tf_address.text = ConstantsModels.static_user?.address
        tf_district.text = ConstantsModels.static_user?.district?.name
        self.idDistric = (ConstantsModels.static_user?.district?.idDistrict)!
        tf_email.text = ConstantsModels.static_user?.userName
    }
    
    @objc func tapCalendar(_ sender: UITapGestureRecognizer) -> Void {
        
        /*let alert = UIAlertController(style: .alert, title: "Distritos")
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: Date()) { date in
            self.date = UtilMethods.intFromDate(date)
            self.tf_birthday.text = UtilMethods.formatDate(date)
        }
        alert.addAction(image: nil, title: "OK", style: .cancel, isEnabled: true, handler: nil)
        self.present(alert, animated: true, completion: nil)*/
        
        
        
        let alert = UIAlertController(style: .alert, title: "Fecha")
        var dateComponents = DateComponents()
        dateComponents.year = 1900
        dateComponents.month = 1
        dateComponents.day = 1
        
        let minDate = Calendar.current.date(from: dateComponents)
        let maxDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        //al constructor del pickerdate le puse mi pickerdate global para que sea su default
        alert.addDatePicker(mode: .date, date: pickerDate, minimumDate: minDate, maximumDate: maxDate ) { date in
            print("datepicker ")
            self.date = UtilMethods.intFromDate(date)
            self.tf_birthday.text = UtilMethods.formatDate(date)
            //actualizo el default cada vez que el usuario cambia l fecha
            self.pickerDate = date
            
            
        }
        
        alert.addAction(image: nil, title: "OK", style: .cancel, isEnabled: true, handler: {(action:UIAlertAction!) in
            print("okAction")
            let auxDate = maxDate
            if (self.tf_birthday.text?.isEmpty)! {
                print("tfIsEmpty")
                //creo esto no se ejecuta, pero lo dejare
                self.date = UtilMethods.intFromDate(auxDate!)
                
                self.tf_birthday.text = UtilMethods.formatDate(auxDate!)
                self.pickerDate = auxDate!
            }})
            //amd
        //seteo el texto al dar ok, a pesar de que es redudante por que ya se hizo en el bloque anterior
        self.tf_birthday.text = UtilMethods.formatDate(self.pickerDate)
        //...
            
            
        self.present(alert, animated: true, completion: nil) 
    }
    
    
    
    @objc func tapDistrict(_ sender: UITapGestureRecognizer) -> Void {
        
        let alert = UIAlertController(style: .alert, title: "Distritos")
        let pickerViewValues: [[String]] = [districts]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: posDistrict)
        
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
        let pickerData = [Constants.X, Constants.MALE, Constants.FEMALE]
        let alert = UIAlertController(style: .alert, title: "Genero")
        let pickerViewValues: [[String]] = [pickerData]
        //amd
        //creo el colGenre fue por gusto al final .-.
        if genre == "M" {
            colGenre = 0
            rowGenre = 1
        }else if genre == "F"{
            colGenre = 0
            rowGenre = 2
        }else if genre == "X"{
            colGenre = 0
            rowGenre = 0
        }
        //...
        
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: colGenre, row: rowGenre)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) {vc , picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    //amd
                    //esto es un desastre D:
                    self.colGenre = index.column
                    self.rowGenre = index.row
                    print("----")
                    print(index.column)
                    print(index.row)
                    if index.row == 1 {
                        self.genre = "M"
                    }else if index.row == 2{
                        self.genre = "F"
                    }else if index.row == 0{
                        self.genre = "X"
                    }
                    //...
                    
                    self.tf_genre.text = pickerViewValues.item(at: index.column)?.item(at: index.row)
                }
            }
        }
        alert.addAction(title: "OK", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDistrict(){
       
        
        Alamofire.request(URLs.ListDistrict, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
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
                    
                    for element in self.districts {
                        
                      
                        if element == ConstantsModels.static_user?.district?.name {
                            self.posDistrict = self.cont
                        }
                        self.cont = self.cont + 1
                    }
                    
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message: jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
                             
        }
    }
    
    
    
    @IBAction func b_save(_ sender: Any) {
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
        } else if self.tf_address.text?.count > 250 {
            AlarmMethods.errorWarning(message: "La dirección no puede tener una extensión mayor a 250 caracteres", uiViewController: self)
            return
        }
        
        if (self.tf_district.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El distrito no puede estar vacío", uiViewController: self)
            return
        } else if self.tf_district.text?.count > 50 {
            AlarmMethods.errorWarning(message: "El distrito no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        }
        
        if tf_phone.text?.count < 9 {
            AlarmMethods.errorWarning(message: "El teléfono debe contener 9 dígitos", uiViewController: self)
            return
        }
        /*if (self.tf_phone.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El teléfono no puede estar vacío", uiViewController: self)
            return
        } else if self.tf_phone.text?.count > 40 {
            AlarmMethods.errorWarning(message: "El teléfono no puede tener una extensión mayor a 40 caracteres", uiViewController: self)
            return
        } else if self.tf_phone.text?.count < 9 {
            AlarmMethods.errorWarning(message: "El teléfono no puede tener una extensión menor a 9 caracteres", uiViewController: self)
            return
        }*/
        
        /*if (self.tf_genre.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El sexo no puede estar vacía", uiViewController: self)
            return
        } else if self.tf_genre.text?.count > 50 {
            AlarmMethods.errorWarning(message: "El sexo  no puede tener una extensión mayor a 50 caracteres", uiViewController: self)
            return
        }*/
        if (self.tf_birthday.text?.isEmpty)! {
            AlarmMethods.errorWarning(message: "El cumpleaños no puede estar vacío", uiViewController: self)
            return
        } else if self.tf_birthday.text?.count > 30 {
            AlarmMethods.errorWarning(message: "El cumpleaños no puede tener una extensión mayor a 30 caracteres", uiViewController: self)
            return
        }
        self.register((PreferencesMethods.getSmallBoxFromOptions()!.GUID))
    }
    
    func register(_ GUID: String){
        PakLoader.show()        
        //var genre : String = "-"
        //if self.tf_genre.text! == "Masculino"  { genre = "M" } else { genre = "F" }
        if posDistrict != -1 {
            self.idDistric =  self.listDistrict[self.posDistrict].idDistrict
        }
        
        let params: Parameters = [
            "IdUsuario" : ConstantsModels.static_user?.idUser ?? 0,
            "Email": self.tf_email.text!,
            "Direccion": self.tf_address.text!,
            "IdDistrito": self.idDistric,
            "Telefono": self.tf_phone.text!,
            "Sexo": genre,
            "FechaNacimiento":self.tf_birthday.text!,
        ]
       
        
        
        Alamofire.request(URLs.ModifyAccount, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            PakLoader.hide()
            if !(response.response != nil) {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                       AlarmMethods.ReadyCustom(message: "Hemos actualizado tu información satisfactoriamente.", title_message: "¡Listo!", uiViewController: self)
                        ConstantsModels.static_user?.userName = self.tf_email.text!
                        ConstantsModels.static_user?.address = self.tf_address.text!
                        ConstantsModels.static_user?.district = self.listDistrict[self.posDistrict]
                        ConstantsModels.static_user?.telephone = self.tf_phone.text!
                        //var genre : String = "-"
                        //if self.tf_genre.text! == "Masculino"  { genre = "M" } else { genre = "F" }
                        ConstantsModels.static_user?.genere = self.genre
                        ConstantsModels.static_user?.birthDate = self.tf_birthday.text!
                        
                                         
                        
                    }else {
                                         
                        if let jsonResponse = response.result.value {
                            let jsonResult = JSON(jsonResponse)
                            AlarmMethods.errorWarning(message: jsonResult["Msg"].string!, uiViewController: self)
                        } else {
                            AlamoMethods.defaultError(self)
                        }
                    }
                }
            } else {
                                 
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message: jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
        }
        
        
    }
    
    @IBAction func b_password_edit(_ sender: Any) {
        alertDialog(uiViewController: self)
        
    }
    
    func alertDialog(uiViewController: UIViewController) {
        let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "vc_pak_modify_password") as! PakAlertModifyPassword
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        uiViewController.present(pakAlert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /*let maxLength = 9
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        print ("estamos en editar")
        return newString.length <= maxLength && newString.length >= maxLength;*/
        
        //amd
        let cs = NSCharacterSet(charactersIn: "0123456789").inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        return (string == filtered)
    }
}
