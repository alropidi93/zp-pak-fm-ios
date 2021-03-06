//
//  PakAlertSummary.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/3/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
class PakAlertSummary : UIViewController, PageObservation , UICollectionViewDelegate , UICollectionViewDataSource , NVActivityIndicatorViewable, UICollectionViewDelegateFlowLayout{
    var parentPageViewController: AlertPageVc!
    private let reuse_identifier_box = "cvc_smallBox_item_Payment"
    
    @IBOutlet weak var l_mount_subt: UILabel!
    @IBOutlet weak var l_total_mount: UILabel!
    @IBOutlet weak var l_mount_delivery: UILabel!
    @IBOutlet weak var l_mount_discount: UILabel!
    @IBOutlet weak var l_discount: UILabel!
    @IBOutlet weak var cv_item_list: UICollectionView!
    private var items : [ItemSmallBoxDC] = []
    
    private var subTotal : Double = 0.0
    private var deliveryCost : Double = 0.0
    private var discountPercent : Double = 0.0
    private var discount : Double = 0.0
    
    //dynamic constraints
    @IBOutlet weak var l_mount_discount_margin_top: NSLayoutConstraint!
    
    //@IBOutlet weak var l_discount_margin_top: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.cv_item_list.delegate = self
        self.cv_item_list.dataSource = self
        getGUID()
    }
    
    @IBAction func b_back(_ sender: Any) {
        parentPageViewController.goBackPage()

    }
    
    
    func getParentPageViewController(parentRef: AlertPageVc) {
        parentPageViewController = parentRef
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier_box, for: indexPath) as! CVCSmallBoxPayment
        cell.l_name.text = self.items[indexPath.item].name
        cell.l_count_item.text = String(self.items[indexPath.item].cant)
        let stringValue = "S/"
        cell.l_mount_total_item.text = stringValue + String(format: "%.2f", Double(self.items[indexPath.item].cant) * self.items[indexPath.item].price)
        return cell
    }
    
    func setSubTotal() {
        self.subTotal = 0
        for element in self.items {
            self.subTotal = self.subTotal + (element.price * Double(element.cant))
        }
        self.discount = self.subTotal * (self.discountPercent / 100 )
        self.l_mount_subt.text = "S/" + String(format: "%.2f", self.subTotal)
        self.l_total_mount.text = "S/" + String(format: "%.2f", self.subTotal + self.deliveryCost - self.discount)
        //self.l_mount_discount.text = "S/" + String(format: "%.2f", self.discount)
        
        
        //amd - text empty on 0.0 discount
        if self.discount != 0.0 {
            self.l_mount_discount.text = "S/" + String(format: "%.2f", self.discount)
        }else{
            self.l_mount_discount.text = ""
        }
    }
    
    func getGUID() {
        let params: Parameters = ["GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID ]
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    let smallBox  = SmallBoxDC(jsonResult)
                    self.l_mount_delivery.text = "S/" + String(format : "%.2f", smallBox.costDelivery)
                    self.deliveryCost = smallBox.costDelivery
                    if smallBox.discount != nil {
                         self.l_discount.text = "Descuento (gracias a " + (smallBox.discount?.detailName)! + ")"
                        self.discountPercent = (smallBox.discount?.percentage)!
                    }else {
                        //amd - text empty on 0.0 discount
                        self.l_mount_discount.text = ""
                        self.l_discount.text = ""
                        //updating margins
                        self.l_mount_discount_margin_top.constant = 0
                        //self.l_discount_margin_top.constant = 0
                        self.view.layoutIfNeeded()
                        //...
                        //self.l_mount_discount.text = "--"
                    }
                    self.items = []
                    for ( _ , element) in jsonResult["Items"] {
                        let smallItemBox  = ItemSmallBoxDC(element)
                        self.items.append(smallItemBox)
                    }
                    self.setSubTotal()
                    self.cv_item_list.reloadData()
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
                             
        }
    }
    
    @IBAction func b_close(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 56)
    }
}

