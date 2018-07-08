//
//  DeliverController.swift
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

class DeliverController : UIViewController ,   NVActivityIndicatorViewable , UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var cv_delivery: UICollectionView!
    let filtre : Int = 1
    var items : [OrderDC] = []
    let segue_identifier = "segue_delivery_todetail"

    private let reuse_identifier = "cvc_delivery"
    var item : Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements(){
        self.ToDeliver()
        
        self.cv_delivery.delegate = self
        self.cv_delivery.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    //29/06/2018 21:06:04
    //    01/07/2018
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCDeliver
        cell.l_total.text = "S/" + String(format : "%.2f",(self.items[indexPath.item].total))
        
        var arr = self.items[indexPath.item].dateToRecive.components(separatedBy: "/")
        cell.l_m_reception.text = UtilMethods.DateIntToString(arr[1])
        cell.l_d_toreception.text = arr[0]
        var arrHour = self.items[indexPath.item].dateToRecive.components(separatedBy: " ")
        var hourtext = arrHour[1].components(separatedBy: ":")
        cell.l_hour_receptionp.text = hourtext[0] + ":" + hourtext[1]
        
        arr = self.items[indexPath.item].dateRecive.components(separatedBy: "/")
        cell.l_m_recive.text = UtilMethods.DateIntToString(arr[1])
        cell.l_d_recive.text = arr[0]
        
        var arrHourR = self.items[indexPath.item].dateRecive.components(separatedBy: " ")
        var hourtextR = arrHourR[1].components(separatedBy: ":")
        
        cell.l_hour_reception.text = hourtextR[0] + ":" + hourtextR[1]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.item = Int(items[indexPath.item].number)
        self.performSegue(withIdentifier: self.segue_identifier, sender: self)
        
        
    }
    func ToDeliver() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        let params: Parameters = [ "IdUsuario": PreferencesMethods.getIdFromOptions() ?? 0,
                                   "Estado": "E" ,
                                   "FiltroMeses" : self.filtre
        ]
        
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
                     

                        self.cv_delivery.reloadData()
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
                vc.type = 2
            }
        }
    }
}
