//
//  ToDeliverController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/29/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import AVFoundation
import SwiftyJSON
import UIKit
import Alamofire
import AVKit
import NVActivityIndicatorView
import Agrume
import PlayerKit
import RLBAlertsPickers

class ToDeliverController : UIViewController ,  NVActivityIndicatorViewable , UICollectionViewDelegate, UICollectionViewDataSource , AlertCancelDelegate, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var cv_to_delivery: UICollectionView!
    
    private let segue_identifier = "segue_todelivery_todetail"
    private let reuse_identifier = "cvc_todelivery"
    @IBOutlet weak var b_filtre: UIButton!
  
    var selected : Int = -1
    
    
    var filtre : Int = 1
    var items : [OrderDC] = []
    var item : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.ToDeliver()
        
        self.cv_to_delivery.delegate = self
        self.cv_to_delivery.dataSource = self
    }
    
    
    
    @IBAction func b_search(_ sender: Any) {
        self.tapFiltre()
    }
    
    func tapFiltre() -> Void {
        
        let pickerData = ["Último mes","Últimos 3 meses","Últimos 6 meses"]
        let pickerData2 = ["Último mes  ▼","Últimos 3 meses  ▼","Últimos 6 meses  ▼"]
        let alert = UIAlertController(style: .actionSheet, title: "")
        let pickerViewValues: [[String]] = [pickerData]
        let pickerViewValues2: [[String]] = [pickerData2]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
     
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) {vc , picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    if index.row == 0{
                        self.filtre = 1
                    }else if index.row == 1{
                        self.filtre = 3
                    }else if index.row == 2 {
                        self.filtre = 6
                    }
                    self.b_filtre.setTitle(pickerViewValues2.item(at: index.column)?.item(at: index.row), for: .normal)
                    self.ToDeliver()
                }
            }
        }
        alert.addAction(title: "OK", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCToDeliver
        cell.l_total.text = "S/" + String(format : "%.2f",(self.items[indexPath.item].total))
        var arr = self.items[indexPath.item].dateToRecive.components(separatedBy: "/")
        cell.l_m_reception.text = UtilMethods.DateIntToStringToSpanish(arr[1])
        cell.l_d_toreception.text = arr[0]
        var arrHour = self.items[indexPath.item].dateToRecive.components(separatedBy: " ")
        var hourtext = arrHour[1].components(separatedBy: ":")
        
        cell.l_hour_reception.text = hourtext[0] + ":" + hourtext[1]
        arr = self.items[indexPath.item].dateOfDelivery.components(separatedBy: "/")
        cell.l_m_recive.text = UtilMethods.DateIntToStringToSpanish(arr[1])
        cell.l_d_recive.text = arr[0]
        cell.l_hour_recive.text = (self.items[indexPath.item].distributionHour?.iniHour)! + " - " + (self.items[indexPath.item].distributionHour?.endHour)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        
        if Date() < UtilMethods.stringToDate(self.items[indexPath.item].dateHourMaxAnulation) {
            cell.l_anular.isHidden = false
            cell.b_cancel.isHidden = false
            cell.b_cancel.tag = indexPath.row
            cell.b_cancel.addTarget(self, action: #selector(cancelOrderFunc), for: .touchUpInside)
        }else {
            cell.l_anular.isHidden = true
            cell.b_cancel.isHidden = true
            cell.b_cancel.isEnabled = false
        }
        return cell
    }
    
    @objc func cancelOrderFunc(sender: UIButton!) {
        self.selected = sender.tag
        self.alertDialogCancelOrder(uiViewController: self)

    }
    
    func okButtonTapped() {
        let order : OrderDC = items[self.selected]
        cancelOrder(Int(order.number) , self.selected)
    }
    func alertDialogCancelOrder(uiViewController: UIViewController) {
        let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "alert_cancel") as! PakAlertCancel
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pakAlert.alertCancel = self
        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        uiViewController.present(pakAlert, animated: true, completion: nil)
    }
    
    
    func cancelOrder(_ idItem : Int ,_ pos : Int) {
       
        
        let params: Parameters = [ "AccessToken": PreferencesMethods.getAccessTokenFromOptions() ?? 0, "Numero": idItem]
        
        Alamofire.request(URLs.CancelOrder, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        self.items.remove(at: pos)
                        self.cv_to_delivery.reloadData()
                        AlarmMethods.ReadyCustom(message: "Tu pedido ha sido anulado con éxito.", title_message: "¡Listo!", uiViewController: self)

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.item = Int(items[indexPath.item].number)
        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
    }
    
    func ToDeliver() {
        
        
        let params: Parameters = [ "IdUsuario": PreferencesMethods.getIdFromOptions() ?? 0, "Estado": "P" , "FiltroMeses" : self.filtre]
        
        Alamofire.request(URLs.ListOrders, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
                return
            }
            
            let statusCode = response.response!.statusCode
            let data = try! JSONSerialization.data(withJSONObject: response.result.value, options: .prettyPrinted)
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print(string)
            
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        self.items = []
                        for ( _ , element) in jsonResult["Pedidos"] {
                            let order  = OrderDC(element)
                            self.items.append(order)
                        }
                        self.cv_to_delivery.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segue_identifier {
            if let vc = segue.destination as? DetailOrderController {
                vc.itemId = self.item
                vc.type = 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 120)
    }
}

