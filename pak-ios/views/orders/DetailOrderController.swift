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

class DetailOrderController : UIViewController ,  NVActivityIndicatorViewable , UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout,AlertCancelDelegate {
    
    
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
    
    //constraint custom
    @IBOutlet weak var btnBottomHeight: NSLayoutConstraint! //def. 60
    var bottomHeight = 60
    //dynamic tableheight
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cvHeight: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.customizeNavigationBarOrders()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(DetailOrderController.description())")
        setElements()
        //sample
        //btnBottomHeight.constant = 0
        //siempre llamar esta vaina
        //self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.getOrder()
        self.cv_detail_order.delegate = self
        self.cv_detail_order.dataSource = self
    }
    
    func updateHeight(){
        print("AMDX: ====================")
        print("AMDX screenHeight: \(UIScreen.main.bounds.height)")
        print("AMDX viewHeight: \(self.view.height)")
        print("AMDX scrollViewHeight: \(scrollView.height)")
        print("AMDX bottomHeight: \(bottomHeight)")
        print("AMDX count: \(self.items.count)")
        let size = self.items.count
        
        //120 es la la altura de la descripccion del pedido
        //112 es la la altura del detalle del costo
        //105 la altura de una celda
        let minHeight =  scrollView.height - 120 - 112  - CGFloat(bottomHeight)
        let totalHeight = CGFloat(size * 105)
        
        print("AMDX minHeight: \(minHeight)")
        print("AMDX totalHeight: \(totalHeight)")
        if minHeight < totalHeight {
            print("Enough height")
            cvHeight.constant = totalHeight
        }else{
            print("Not enough height")
            cvHeight.constant = minHeight
        }
        self.view.layoutIfNeeded()
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
            
            btnBottomHeight.constant = 0
            bottomHeight = 0
            
            self.updateHeight()
            //siempre llamar esta vaina
            self.view.layoutIfNeeded()
        } else if type == 3{
            
            if self.order?.state == "A"{
                l_delivery_cancel.text = "Anulado"
            }else if self.order?.state == "C"{
                l_delivery_cancel.text = "Cancelado"
            }            
            l_order.text = order?.dateToRecive
            l_delivery.text = order?.dateCancel
            
            btnBottomHeight.constant = 0
            bottomHeight = 0
            self.updateHeight()
            //siempre llamar esta vaina
            self.view.layoutIfNeeded()
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
       
        
        let params: Parameters = [ "Numero": itemId ]
        
        Alamofire.request(URLs.GerOrder, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                 
                return
            }
            print ("=========================")
            let statusCode = response.response!.statusCode
            let data = try! JSONSerialization.data(withJSONObject: response.result.value, options: .prettyPrinted)
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print(string)
            print ("=========================")
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
                        if self.type == 1 {
                            
                            if Date() < UtilMethods.stringToDate((self.order?.dateHourMaxAnulation)!) {
                                print("holiwiasdasd")
                                self.b_anular.setTitle("Anular pedido", for: .normal)
                                self.b_anular.isUserInteractionEnabled = true
                                self.b_anular.backgroundColor = #colorLiteral(red: 1, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
                            }else {
                                self.b_anular.isUserInteractionEnabled = false
                            }
                        }
                        self.updateHeight()
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
                             
        }
    }
    func customizeNavigationBarOrders( ) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "dwb_pak_button_header_back"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(buttonBackAction))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = backBTN
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(rgb: 0x81D34C)
        
        
        
        
        let navView = UIView()
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 25)
        
        label.text = "Mis pedidos"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        let image = UIImageView()
        image.image = UIImage(named: "dwb_pak_button_orders")
        let imageAspect = image.image!.size.width/image.image!.size.height
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIViewContentMode.scaleAspectFit
        
        
        let image2 = UIImageView(image: #imageLiteral(resourceName: "dwb_pak_button_orders_title"))
        image2.frame = CGRect(
            x: label.frame.origin.x-label.frame.size.height*imageAspect,
            y: label.frame.origin.y + 6,
            width: image2.width,
            height: image2.height
        )
        
        navView.addSubview(label)
        navView.addSubview(image2)
        self.navigationItem.titleView = navView
        navView.sizeToFit()
        
       
        if ConstantsModels.count_item == 0 {
            var btnsMenuRight : [UIBarButtonItem] = []
            let btnMenuRight = UIBarButtonItem(image: UIImage(named: "dwd_pak_box_tittle_bar"), style: .plain, target: self, action: #selector(didPressRightButton))
            btnsMenuRight.append(btnMenuRight)
            self.navigationItem.rightBarButtonItems = btnsMenuRight
            
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0x81D34C)
        }else {
            let notificationButton = SSBadgeButton()
            notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            notificationButton.setImage(UIImage(named: "dwd_pak_box_tittle_bar")?.withRenderingMode(.alwaysTemplate), for: .normal)
            notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 40)
            notificationButton.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
            notificationButton.badge = "\(ConstantsModels.count_item) "
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        }
        
    }
    
    @objc func buttonBackAction (_ sender: Any) {
         dismiss(animated: true, completion: nil)
       
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Log 8: Columnas responsive
        let cell_width = UIScreen.main.bounds.width
        return CGSize(width: cell_width, height: 105)
    }
    
    
    @IBOutlet var b_anular: UIButton!
    
    @IBAction func b_anular(_ sender: Any) {
        let pakAlert = self.storyboard?.instantiateViewController(withIdentifier: "alert_cancel") as! PakAlertCancel
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pakAlert.alertCancel = self
        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(pakAlert, animated: true, completion: nil)
       
    }
    
    func okButtonTapped() {
        cancelOrder(self.itemId)
    }
    

    
    
    func cancelOrder(_ idItem : Int ) {
        PakLoader.show()
        let params: Parameters = [ "AccessToken": PreferencesMethods.getAccessTokenFromOptions() ?? 0, "Numero": idItem]
        
        Alamofire.request(URLs.CancelOrder, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            PakLoader.hide()
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self) 
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{

                        AlarmMethods.ReadyCustomWithPushBack(message: "Tu pedido ha sido anulado con éxito.", title_message: "¡Listo!", uiViewController: self)
                        
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
    
}

