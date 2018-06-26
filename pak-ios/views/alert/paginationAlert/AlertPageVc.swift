//
//  AlertPageVC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/2/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class AlertPageVc : UIPageViewController,  UIPageViewControllerDelegate {
    var controllers = [UIViewController]()
    var nowPage = 0
    
    var pageNow : Int = 1
    //boleta 0 factura 1
    var boletaOrFactura : Int = 0
    
    var checkOut = CheckOut()
    var dataDelivery : DataDeliveryDC? = nil
    
    var titular :String = ""
    var numTarjeta : String = ""
    var expiredDate : String = ""
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
            if (/*validateFirstController() == true*/ true){
                let viewController = self.VCArr[position]
                setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion:nil)
                self.pageNow = self.pageNow + 1 
            }
            else {
                //crear alerta 
                print("1")
            }
            
        case 2:
            print(validateSecondController())
            print("2")
        case 3:
            print("3")
        case 4:
            print("4")
        default:
            return
        }
        
        
        
    }
    func printfc() {
        print("holiiii")
        
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
    func validateThirdController() -> Bool {
        return true
    }
    func validateCulqi(){
        
    }
}
