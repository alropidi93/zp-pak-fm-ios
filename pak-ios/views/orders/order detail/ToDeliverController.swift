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

class ToDeliverController : UIViewController ,  NVActivityIndicatorViewable , UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var cv_to_delivery: UICollectionView!
    
    private let segue_identifier = "segue_todelivery_todetail"
    private let reuse_identifier = "cvc_todelivery"
    
    let filtre : Int = 1
    var items : [OrderDC] = []
    var item : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.tapGenre()
    }
    
    func tapGenre() -> Void {
        let pickerData = [Constants.MALE,Constants.FEMALE]
        let alert = UIAlertController(style: .actionSheet, title: "Genero")
        let pickerViewValues: [[String]] = [pickerData]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
     
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) {vc , picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    print(pickerViewValues.item(at: index.column)?.item(at: index.row))
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
        cell.l_m_reception.text = UtilMethods.DateIntToString(arr[1])
        cell.l_d_toreception.text = arr[0]
        var arrHour = self.items[indexPath.item].dateToRecive.components(separatedBy: " ")
        var hourtext = arrHour[1].components(separatedBy: ":")
        
        cell.l_hour_reception.text = hourtext[0] + ":" + hourtext[1]
        arr = self.items[indexPath.item].dateOfDelivery.components(separatedBy: "/")
        cell.l_m_recive.text = UtilMethods.DateIntToString(arr[1])
        cell.l_d_recive.text = arr[0]
        cell.l_hour_recive.text = (self.items[indexPath.item].distributionHour?.iniHour)! + " - " + (self.items[indexPath.item].distributionHour?.endHour)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        print(Date().toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZ"))
        print(UtilMethods.stringToDate(self.items[indexPath.item].dateHourMaxAnulation).toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZZZ"))
        if Date() < UtilMethods.stringToDate(self.items[indexPath.item].dateHourMaxAnulation) {
            cell.ui_cancel.isHidden = false
            cell.l_cancel.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.item = Int(items[indexPath.item].number)
        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
    }
    
    func ToDeliver() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        let params: Parameters = [ "IdUsuario": PreferencesMethods.getIdFromOptions() ?? 0, "Estado": "P" , "FiltroMeses" : self.filtre]
        
        Alamofire.request(URLs.ListOrders, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
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
            self.stopAnimating()
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
}

