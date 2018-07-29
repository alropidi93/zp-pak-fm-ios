//
//  DetailOrderController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 7/2/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//


import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import AVKit
import NVActivityIndicatorView
import Agrume
import PlayerKit

class DetailOrderController : UIViewController ,  NVActivityIndicatorViewable , UICollectionViewDelegate, UICollectionViewDataSource  {
    @IBOutlet weak var cv_detail_order: UICollectionView!
    @IBOutlet weak var l_number: UILabel!
    @IBOutlet weak var l_order: UILabel!
    @IBOutlet weak var l_delivery: UILabel!
    @IBOutlet weak var l_address: UILabel!
    @IBOutlet weak var l_delivery_cancel: UILabel!
    @IBOutlet weak var l_subtotal: UILabel!
    @IBOutlet weak var l_delivery_cost: UILabel!
    @IBOutlet weak var l_total: UILabel!
    
    private let reuse_identifier = "cvc_order_detail"
    
    var type : Int = -1
    var itemId : Int = -1
    var items : [ItemOrderDC] = []
    var order : OrderDC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.getOrder()
        self.cv_detail_order.delegate = self
        self.cv_detail_order.dataSource = self
    }
    
    func setLabels() {
        l_number.text = "\(String(describing: order?.number ?? 0))"
        l_address.text = order?.address
        if type == 1{
            l_order.text = order?.dateToRecive
            l_delivery.text = (order?.dateOfDelivery)! + " " + (order?.distributionHour?.iniHour)! + "-" + (order?.distributionHour?.endHour)!
        } else if type == 2{
            l_order.text = order?.dateToRecive
            l_delivery.text = order?.dateCancel
        } else if type == 3{
            l_delivery_cancel.text = "Anulado"
            l_order.text = order?.dateToRecive
            l_delivery.text = order?.dateCancel
        }
        
        l_subtotal.text = "S/" + String(format : "%.2f",(order?.subTotal)!)
        
        l_delivery_cost.text = "S/" + String(format : "%.2f",(order?.deliveryCost)!)
        l_total.text = "S/" + String(format : "%.2f",(order?.total)!)
 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCDetailOrder
        cell.l_name.text = self.items[indexPath.item].name
        cell.l_cant.text = String(self.items[indexPath.item].cant)
        let stringValue = "S/"
        
        cell.l_mount_total_item.text = stringValue + String(format : "%.2f",(Double(self.items[indexPath.item].cant) * self.items[indexPath.item].price))
        
        cell.l_price.text = stringValue + String(format : "%.2f",(self.items[indexPath.item].price))

        UtilMethods.setImage(imageview: cell.iv_product, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        return cell
    }
    
    func getOrder() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        let params: Parameters = [ "Numero": itemId ]
        
        Alamofire.request(URLs.GerOrder, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        self.order = OrderDC(jsonResult)
                        self.items = []
                        for ( _ , element) in jsonResult["Items"] {
                            let order  = ItemOrderDC(element)
                            self.items.append(order)
                        }
                        self.setLabels()
                        self.cv_detail_order.reloadData()
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
}

