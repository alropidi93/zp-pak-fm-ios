//
//  SmallBoxController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/21/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView
import FacebookCore
import FacebookLogin
import SwiftHash
import SideMenu

class SmallBoxController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,NVActivityIndicatorViewable{
    @IBOutlet weak var emptyImg: UIView!
    
    @IBOutlet weak var b_buying: UIButton!
    @IBOutlet weak var dwb_pak_button_detail_white_arrow_down: UIImageView!
    @IBOutlet weak var v_head: UIView!
    @IBOutlet weak var v_total: UIView!
    @IBOutlet weak var l_mount_subt: UILabel!
    @IBOutlet weak var l_mount_delivery: UILabel!
    @IBOutlet weak var l_mount_total: UILabel!
    @IBOutlet weak var cv_item_list: UICollectionView!
    @IBOutlet weak var l_discount: UILabel!
    @IBOutlet weak var l_mount_discount: UILabel!
    
    private let reuse_identifier_box = "cvc_smallBox_item"
    private var items : [ItemSmallBoxDC] = []
    private var dataDelivery : DataDeliveryDC? = nil
    private var deliveryCost : Double = 0.0
    private var subTotal : Double = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
        navBarLabelWithImg()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier_box, for: indexPath) as! CVCSmallBoxItem
        cell.l_name.text = self.items[indexPath.item].name
        cell.tf_count_item.text = String(self.items[indexPath.item].cant)
        cell.tf_count_item.backgroundColor = UIColor.lightGray
        cell.tf_count_item.tag = indexPath.row
        cell.tf_count_item .addTarget(self, action: #selector(textFieldEditingDidChangeEnd), for: UIControlEvents.editingDidEnd)
        let stringValue = "S./"
        cell.l_mount_total_item.text = stringValue + String(Double(self.items[indexPath.item].cant) * self.items[indexPath.item].price)
        cell.l_price.text = stringValue + String(self.items[indexPath.item].price)
        
        UtilMethods.setImage(imageview: cell.iv_product, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        return cell
    }
    
    @objc func textFieldEditingDidChangeEnd(sender: UITextField!) {
        if sender.text?.isEmpty == false {
            
            let cant = UInt64(sender.text!)!
            modifyItemSmallBox(items[sender.tag],cant)
            
            }
    }
    
    func modifyItemSmallBox(_ itemProduct:ItemSmallBoxDC , _ cant : UInt64){
        
        let params : Parameters = [ "IdProducto": itemProduct.idProduct,
                       "Cantidad":cant,
                       "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID ]
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        Alamofire.request(URLs.ModifySmallBox , method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
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
                        itemProduct.cant = cant
                        self.setSubTotal()
                    }
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
            self.stopAnimating()
        }
    }
 
    
    func setElements(){
        self.cv_item_list.delegate = self
        self.cv_item_list.dataSource = self
        getGUID()
    }
    
    func showOrHidenItems(){
        if items.count > 0 {
            self.emptyImg.isHidden = true
            
            self.b_buying.isHidden = false
            self.dwb_pak_button_detail_white_arrow_down.isHidden = false
            self.v_head.isHidden = false
            self.cv_item_list.isHidden = false
            self.v_total.isHidden = false
            self.setSubTotal()
        } else {
            self.emptyImg.isHidden = false
            
            self.b_buying.isHidden = true
            self.dwb_pak_button_detail_white_arrow_down.isHidden = true
            self.v_head.isHidden = true
            self.cv_item_list.isHidden = true
            self.v_total.isHidden = true
        }
    }
    
    func setSubTotal(){
        self.subTotal = 0
        for element in self.items {
            self.subTotal = self.subTotal + (element.price * Double(element.cant))
        }
        self.l_mount_subt.text = "S/" + String(self.subTotal)
        self.l_mount_total.text = "S/" + String(self.subTotal + self.deliveryCost )
    }
    
    func getGUID() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        let params: Parameters = ["GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID ]
        print(PreferencesMethods.getSmallBoxFromOptions()!.GUID)
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    let smallBox  = SmallBoxDC(jsonResult)
                    self.deliveryCost = smallBox.costDelivery
                    self.l_mount_delivery.text = String(self.deliveryCost)

                    self.items = []
                    for ( _ , element) in jsonResult["Items"] {
                        let smallItemBox  = ItemSmallBoxDC(element)
                        self.items.append(smallItemBox)
                    }
                    self.cv_item_list.reloadData()
                    self.showOrHidenItems()
                    
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }

    
    

    
    
    
    func getDataDelivery() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        let params: Parameters = ["GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID ]
        print(PreferencesMethods.getSmallBoxFromOptions()!.GUID)
        Alamofire.request(URLs.DataDelivery, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Data"] == true {
                        self.dataDelivery  = DataDeliveryDC(jsonResult)
                        self.customAlertPayment()
                    }else{
                        let jsonResult = JSON(jsonResponse)
                        print(jsonResult["MontoMinimo"])
                        AlarmMethods.errorWarning(message: "El monto mínimo para el pedido es de S/ " + jsonResult["MontoMinimo"].stringValue + " (sin incluir costo de delivery).", uiViewController: self)
                    }
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
    
    @IBAction func ba_buying(_ sender: Any) {
        self.getDataDelivery()
        
    }
    
    func customAlertPayment(){
        
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "alert_payment") as! AlertViewPayment
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.dataDelivery = self.dataDelivery
        
        self.present(customAlert, animated: true, completion: nil)
    }
    
    func navBarLabelWithImg(){
        self.navigationController?.navigationBar.shadowImage = UIImage()

        let navView = UIView()
        let label = UILabel()
        label.text = "  Mi cajita"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        let image = UIImageView()
        image.image = UIImage(named: "dwd_pak_box_tittle_bar")
        let imageAspect = image.image!.size.width/image.image!.size.height
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIViewContentMode.scaleAspectFit
        navView.addSubview(label)
        navView.addSubview(image)
        self.navigationItem.titleView = navView
        navView.sizeToFit()
    }
}
