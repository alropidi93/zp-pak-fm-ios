//
//  AlertPageVC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/2/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class AlertPageVc : UIPageViewController,  UIPageViewControllerDelegate, NVActivityIndicatorViewable {
    var finishBoxDelegate : FinishBoxDelegate? = nil
    var controllers = [UIViewController]()
    var nowPage = 0

    var segue_parent = "segue_embed_page_vc"
    var parentVC : AlertViewPayment? = nil
    var pageNow : Int = 1
    //boleta 0 factura 1
    var boletaOrFactura : Int = 0

    var checkOut = CheckOut()
    var dataDelivery : DataDeliveryDC? = nil

    var titular :String = ""
    var numTarjeta : String = ""
    var expiredDateMM : String = ""
    var expiredDateYYYY : String = ""
    var ccv : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")

        if let firstVC = VCArr.first {
            setViewControllers([firstVC], direction: .forward, animated: true , completion: nil)
        }
        self.delegate = self
    }

    lazy var VCArr : [UIViewController] = {
        return [self.VCInstance(name: "v_send_data"),
                self.VCInstance(name: "v_alert_facturation"),
                self.VCInstance(name: "v_card_data"),
                self.VCInstance(name: "v_order_summary")]
    }()

    private func VCInstance(name : String ) -> UIViewController {
        let childViewController = UIStoryboard(name : "Main", bundle : nil).instantiateViewController(withIdentifier : name)
        let childViewParent = childViewController as! PageObservation
        childViewParent.getParentPageViewController(parentRef: self)
        return childViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        nowPage = VCArr.index(of: viewController) ?? VCArr.count - 1
        if nowPage + 1 >= VCArr.count {
            return nil
        }
        return VCArr[nowPage + 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        nowPage = VCArr.index(of: viewController) ?? 0
        if nowPage - 1 < 0 {
            return nil
        }
        return VCArr[nowPage - 1]
    }

    func goBackPage() {
        print("AMD <- ")
        print(self.pageNow)
        self.pageNow = self.pageNow - 1

        let viewController = self.VCArr[self.pageNow - 1]
        setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion:nil)
        print(self.pageNow)
        // amd - se mostrara 'Siguiente' cada vez que se retroceda
        self.parentVC?.b_next.setTitle("Siguiente", for: .normal)

    }

    func goNextPage(forwardTo position: Int) {
        print("AMD -> \(position)")
        switch position {
        case 1:
            if (validateFirstController() == true){
                let viewController = self.VCArr[position]
                setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion:nil)
                print(self.pageNow)
                self.pageNow = self.pageNow + 1
            }
            else {
                 AlarmMethods.ReadyCustom(message: "Debes completar todos los campos", title_message: "¡Oops!", uiViewController: self)
                print("1")
            }
        case 2:
            if validateSecondController() == true{
                let viewController = self.VCArr[position]
                setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion:nil)
                self.pageNow = self.pageNow + 1
            }else{
                AlarmMethods.ReadyCustom(message: "Debes completar todos los campos", title_message: "¡Oops!", uiViewController: self)
            }
        case 3:
            if validateTextTarjeta() == true {
                validateThirdController()
            }else{
                AlarmMethods.ReadyCustom(message: "Debes completar todos los campos", title_message: "¡Oops!", uiViewController: self)
            }

        case 4:
            validatePayController()
        default:
            return
        }
    }

    func validateFirstController()  -> Bool {
        if checkOut.address != "" && checkOut.district != 0 && checkOut.recipentName != "" && checkOut.hourlySale != "" && checkOut.date != "" {
            return true
        }
        AlarmMethods.ReadyCustom(message: "Debes completar todos los campos", title_message: "¡Oops!", uiViewController: self)
        return false
    }

    func validateSecondController() -> Bool {
        if boletaOrFactura == 1{
            if checkOut.ruc != "" && checkOut.businessName != "" && checkOut.fiscalAddress != "" && checkOut.ruc.count == 11{
                return true
            }else if checkOut.ruc.count != 11{
                AlarmMethods.ReadyCustom(message: "El número de RUC debe tener 11 dígitos.", title_message: "¡Oops!", uiViewController: self)
                return false
            } else {
                AlarmMethods.ReadyCustom(message: "Debes completar todos los campos", title_message: "¡Oops!", uiViewController: self)
                return false
            }
        }else {

            return true
        }
    }


    func validateTextTarjeta() -> Bool {
        if titular != "" && numTarjeta != "" && expiredDateMM != "" && expiredDateYYYY != "" && ccv != ""{
            return true
        }
        AlarmMethods.ReadyCustom(message: "Debes completar todos los campos", title_message: "¡Oops!", uiViewController: self)
        return false
    }

    func validateThirdController() {
        validateCulqi()
    }

    func validatePayController() {
        payment()
    }

    func payment() {
        self.parentVC?.b_next.isEnabled = false

        PakLoader.show()
        //self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        var params: Parameters = [:]
        if boletaOrFactura == 0 {
            params = [ "GUID" : PreferencesMethods.getSmallBoxFromOptions()?.GUID ?? "" , "Direccion" : checkOut.address, "IdDistrito" : checkOut.district, "Referencia" : checkOut.reference, "TipoFacturacion" : "B", "NombreDestinatario": checkOut.recipentName, "FechaEntrega":checkOut.date, "VentanaHoraria":checkOut.hourlySale, "Token":checkOut.token]

        } else if boletaOrFactura == 1 {
            params = [ "GUID" : PreferencesMethods.getSmallBoxFromOptions()?.GUID ?? "" , "Direccion" : checkOut.address, "IdDistrito" : checkOut.district, "Referencia" : checkOut.reference, "TipoFacturacion" : "F", "RUC" : checkOut.ruc, "RazonSocial" : checkOut.businessName , "DireccionFiscal" : checkOut.fiscalAddress, "NombreDestinatario": checkOut.recipentName, "FechaEntrega":checkOut.date, "VentanaHoraria":checkOut.hourlySale, "Token":checkOut.token]
        }

        
        Alamofire.request(URLs.Payment, method: .post, parameters: params ,encoding: JSONEncoding.default).responseJSON { response in
            PakLoader.hide()
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {

                    let jsonResult = JSON(jsonResponse)
                    let data = try! JSONSerialization.data(withJSONObject: response.result.value, options: .prettyPrinted)
                    let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print(string)

                    if jsonResult["Msg"] == "OK"{
                        print("AMD payment OK")
                        ConstantsModels.count_item = 0
                        let cajita = PreferencesMethods.getSmallBoxFromOptions()
                        cajita?.items.removeAll()
                        
                        PreferencesMethods.saveSmallBoxToOptions(cajita!)
                        
                        self.dismiss(animated: false, completion: nil)
                        self.finishBoxDelegate?.okButtonTapped()
                        self.stopAnimating()
                        self.parentVC?.b_next.isEnabled = true
                        
                        
                        

                    }else {
                        self.parentVC?.b_next.isEnabled = true

                        AlarmMethods.ReadyCustom(message: "Se ha llegado al límite de pedidos para este horario de reparto.", title_message: "¡Oops!", uiViewController: self)
                    }
                }
            } else {
                self.parentVC?.b_next.isEnabled = true

                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)
            }
        }
                         
    }



    func validateCulqi() {
        PakLoader.show()
        let headersHttp: HTTPHeaders = ["Content-Type" : "application/json; charset=utf-8", "Authorization": "Bearer " + Constants.CULQI_KEY ]
        let params: Parameters = [ "email" : ConstantsModels.static_user!.userName , "card_number": self.numTarjeta, "public_key":Constants.CULQI_KEY, "cvv": self.ccv, "expiration_year": self.expiredDateYYYY, "expiration_month":expiredDateMM, "fingerprint": 89]

        Alamofire.request(URLs.CulqiValidation, method: .post, parameters: params ,encoding: JSONEncoding.default, headers: headersHttp).responseJSON { response in
            PakLoader.hide()
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
                return
            }

            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["object"].string! == "token"{
                        let id  = jsonResult["id"]
                        self.checkOut.token = id.string!
                        let viewController = self.VCArr[3]

                        self.setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion:nil)
                        self.pageNow = self.pageNow + 1
                        self.parentVC?.b_next.setTitle("Pagar", for: .normal)

                        self.stopAnimating()
                    }else{
                        AlarmMethods.errorWarning(message: jsonResult["merchant_message"].string!, uiViewController: self)
                        print("3")
                                         
                    }
                }
            } else {
                print("3")
                AlamoMethods.defaultError(self)
            }
        }
    }
}
