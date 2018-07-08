//
//  OrdersController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/29/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
import Tabman
import Pageboy
import SideMenu

class OrdersController : TabmanViewController, PageboyViewControllerDataSource {
    var searchWord : String = ""
    
    private let viewControllers : [UIViewController] = [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc_to_deliver"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc_deliver"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc_canceled")
    ]
    
    var visibleControllerIndex : Int = -1
    
    /* #MARK: Default methods */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.dataSource = self
        self.bar.items = [Item(title: "Por Entregar"), Item(title: "Entregados"), Item(title: "Anulados")]
        customizeTabBar()
    }
    
    /* #MARK: Tabman methods and customization */
    func customizeTabBar() {
        self.bar.style = .buttonBar
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.style.background = .solid(color: UtilMethods.hexStringToUIColor(hex: Constants.LIGHT_GRAY))
            appearance.indicator.color = UtilMethods.hexStringToUIColor(hex: Constants.GREEN_PAK)
            
            appearance.layout.itemDistribution = .centered
            appearance.state.color = UIColor.lightGray
            appearance.state.selectedColor = UIColor.black
            appearance.layout.edgeInset = 0.0
            appearance.text.font = UIFont(name: "HelveticaNeue", size: 15)
        })
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        self.visibleControllerIndex = index
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
