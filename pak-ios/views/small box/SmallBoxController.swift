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
import SwipeCellKit

class SmallBoxController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,NVActivityIndicatorViewable,FinishBoxDelegate,SwipeCollectionViewCellDelegate{
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
    let segue_identifier = "segue_box_close"

    private let segue_identification = "segue_buy_loguin"
    private var items : [ItemSmallBoxDC] = []
    private var dataDelivery : DataDeliveryDC? = nil
    private var deliveryCost : Double = 0.0
    private var subTotal : Double = 0.0
    private var discountPercent : Double = 0.0
    private var discount : Double = 0.0
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
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Eliminar") { action, indexPath in
            self.deleteItem(self.items[indexPath.row], indexPath.row)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier_box, for: indexPath) as! CVCSmallBoxItem
        cell.delegate = self
        cell.l_name.text = self.items[indexPath.item].name
        cell.tf_count_item.text = String(self.items[indexPath.item].cant)
//        cell.tf_count_item.backgroundColor = UIColor.lightGray
        cell.tf_count_item.tag = indexPath.row
        cell.tf_count_item .addTarget(self, action: #selector(textFieldEditingDidChangeEnd), for: UIControlEvents.editingDidEnd)
        let stringValue = "S/"
        
        cell.l_mount_total_item.text = stringValue + String(format: "%.2f" ,Double(self.items[indexPath.item].cant) * self.items[indexPath.item].price)
        cell.l_price.text = stringValue + String(format : "%.2f",(self.items[indexPath.item].price))
        
        UtilMethods.setImage(imageview: cell.iv_product, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        return cell
    }
    
    @objc func textFieldEditingDidChangeEnd(sender: UITextField!) {
        if sender.text?.isEmpty == false {
            let cant = UInt64(sender.text!)!
            modifyItemSmallBox(items[sender.tag],cant)
        }
    }
    
    func deleteItem(_ itemProduct:ItemSmallBoxDC , _ pos : Int ) {
        let params : Parameters = [ "IdProducto": itemProduct.idProduct,
                                    
                                    "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID ]
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        Alamofire.request(URLs.DeleteItem , method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
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
                        ConstantsModels.count_item = ConstantsModels.count_item - self.items.count
                        self.items.remove(at: pos)
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
    
    
    
    func modifyItemSmallBox(_ itemProduct:ItemSmallBoxDC , _ cant : UInt64) {
        let params : Parameters = [ "IdProducto": itemProduct.idProduct,
                                    "Cantidad":cant,
                                    "GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID ]
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        Alamofire.request(URLs.ModifySmallBox , method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
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
    
    func setElements() {
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
    
    func setSubTotal() {
        self.subTotal = 0
        ConstantsModels.count_item = 0
        for element in self.items {
            self.subTotal = self.subTotal + (element.price * Double(element.cant))
            ConstantsModels.count_item = ConstantsModels.count_item + Int(element.cant)
        }
        self.discount = self.subTotal * (self.discountPercent / 100 )
        self.l_mount_subt.text = "S/" + String(format: "%.2f",self.subTotal)
        self.l_mount_total.text = "S/" + String(self.subTotal + self.deliveryCost - self.discount)
        self.l_mount_discount.text = "S/" + String(format: "%.2f", self.discount)
    }
    
    func getGUID() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        let params: Parameters = ["GUID" : PreferencesMethods.getSmallBoxFromOptions()!.GUID ]
        print(PreferencesMethods.getSmallBoxFromOptions()!.GUID)
        Alamofire.request(URLs.GetGUID, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    let smallBox  = SmallBoxDC(jsonResult)
                    self.deliveryCost = smallBox.costDelivery
                    self.l_mount_delivery.text = "S/" + String(self.deliveryCost)
                    if smallBox.discount != nil {
                        
                        self.l_discount.text = "Descuento (gracias a " + (smallBox.discount?.detailName)! + ")"
                        self.discountPercent = (smallBox.discount?.percentage)!
                    }else {
                        self.l_mount_discount.text = "--"
                    }
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
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

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
                        AlarmMethods.ReadyCustom(message: "El monto mínimo para el pedido es de S/ " + String(format: "%.2f",jsonResult["MontoMinimo"].doubleValue) + " (sin incluir costo de delivery).", title_message: "¡Oops!", uiViewController: self)
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
        if ConstantsModels.static_user != nil {
            self.getDataDelivery()
        }else{
            self.performSegue(withIdentifier: self.segue_identification , sender: self)
        }
        
    }
    
    func customAlertPayment() {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "alert_payment") as! AlertViewPayment
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.dataDelivery = self.dataDelivery
        customAlert.finishBoxDelegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
    
    
    func okButtonTapped() {

        self.performSegue(withIdentifier: self.segue_identifier, sender: self)

    }
    
    
    func navBarLabelWithImg() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navView = UIView()
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 25)

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

