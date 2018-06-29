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

class AlertPageVc : UIPageViewController,  UIPageViewControllerDelegate ,NVActivityIndicatorViewable {
    var controllers = [UIViewController]()
    var nowPage = 0
    
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
  
    
    func goNextPage(forwardTo position: Int) {
       
        switch position {
        case 1:
            if (validateFirstController() == true){
                let viewController = self.VCArr[position]
                setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion:nil)
                self.pageNow = self.pageNow + 1 
            }
            else {
                //crear alerta 
                print("1")
            }
            
        case 2:
            if validateSecondController() == true{
                let viewController = self.VCArr[position]
                setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion:nil)
                self.pageNow = self.pageNow + 1
            }else{
                print("2")

            }
        case 3:
             validateThirdController()
        case 4:
            validatePayController()
        default:
            return
        }
    }
   
    func validateFirstController()  -> Bool{
        if checkOut.address != "" && checkOut.district != 0 && checkOut.reference != "" && checkOut.recipentName != "" && checkOut.hourlySale != "" && checkOut.date != "" {
            return true
        }
        return false
    }
    func validateSecondController() -> Bool {
        if boletaOrFactura == 1{
            if checkOut.ruc != "" && checkOut.businessName != "" && checkOut.fiscalAddress != "" {
                return true
            }else {
                return false
            }
        }else {
                return true
        }
    }
    
    func validateThirdController()  {
        validateCulqi()
    }
    func validatePayController()  {
        payment()
       
    }
    func payment(){
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        var params: Parameters = [:]
        if boletaOrFactura == 0 {
            params = [ "GUID" : PreferencesMethods.getSmallBoxFromOptions()?.GUID ?? "" ,
                                       "Direccion" : checkOut.address,
                                       "IdDistrito" : checkOut.district,
                                       "Referencia" : checkOut.reference,
                                       "TipoFacturacion" : "B",
                                       "NombreDestinatario": checkOut.recipentName,
                                       "FechaEntrega":checkOut.date,
                                       "VentanaHoraria":checkOut.hourlySale,
                                       "Token":checkOut.token]
            
        }else if boletaOrFactura == 1 {
            params = [ "GUID" : PreferencesMethods.getSmallBoxFromOptions()?.GUID ?? "" ,
                                       "Direccion" : checkOut.address,
                                       "IdDistrito" : checkOut.district,
                                       "Referencia" : checkOut.reference,
                                       "TipoFacturacion" : "F",
                                       "RUC" : checkOut.ruc,
                                       "RazonSocial" : checkOut.businessName ,
                                       "DireccionFiscal" : checkOut.fiscalAddress,
                                       "NombreDestinatario": checkOut.recipentName,
                                       "FechaEntrega":checkOut.date,
                                       "VentanaHoraria":checkOut.hourlySale,
                                       "Token":checkOut.token]
        }
        print(PreferencesMethods.getSmallBoxFromOptions()?.GUID )
        print(checkOut.address)
        print( checkOut.district )
        print(checkOut.reference )
        print(checkOut.recipentName + "--" + checkOut.date + "--" + checkOut.hourlySale + "--" + checkOut.token )
        Alamofire.request(URLs.Payment, method: .post, parameters: params ,encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    print(jsonResult["Msg"])
                    self.stopAnimating()

                }
            } else {
                AlamoMethods.defaultError(self)
            }
        }
        self.stopAnimating()

    
    }
    
    func validateCulqi()  {
        
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        let headersHttp: HTTPHeaders = ["Content-Type" : "application/json; charset=utf-8",
                                    "Authorization": "Bearer " + Constants.CULQI_KEY ]
        let params: Parameters = [ "email" : ConstantsModels.UserStatic!.userName ?? "",
                                   "card_number": self.numTarjeta,
                                   "public_key":Constants.CULQI_KEY,
                                   "cvv": self.ccv,
                                   "expiration_year": self.expiredDateYYYY ,
                                   "expiration_month":expiredDateMM,
                                   "fingerprint": 89]
        
        Alamofire.request(URLs.CulqiValidation, method: .post, parameters: params ,encoding: JSONEncoding.default, headers: headersHttp).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
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
                        self.stopAnimating()
                    }else{
                        AlarmMethods.errorWarning(message: jsonResult["merchant_message"].string!, uiViewController: self)
                        print("3")
                        self.stopAnimating()

                    }
                }
            } else {
                print("3")

                AlamoMethods.defaultError(self)
   
            }
       }
    }
}
