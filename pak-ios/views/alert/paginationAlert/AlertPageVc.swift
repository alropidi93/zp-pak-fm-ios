//
//  AlertPageVC.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/2/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class AlertPageVc : UIPageViewController,  UIPageViewControllerDelegate , UIPageViewControllerDataSource

{
    var controllers = [UIViewController]()
    var nowPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        super.viewDidLoad()
        
        if let firstVC = VCArr.first{
            setViewControllers([firstVC], direction: .forward, animated: true , completion: nil)
        }
        self.dataSource = self
        self.delegate = self
    }
    
    lazy var VCArr : [UIViewController] = {
        return [self.VCInstance(name: "v_send_data"),
                self.VCInstance(name: "v_alert_facturation"),
                self.VCInstance(name: "v_card_data"),
                self.VCInstance(name: "v_order_summary"),
                ]
    }()
    
    private func VCInstance(name : String ) -> UIViewController{
        return UIStoryboard(name : "Main", bundle : nil).instantiateViewController(withIdentifier : name)
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
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArr.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return nowPage
    }
    
    
}
