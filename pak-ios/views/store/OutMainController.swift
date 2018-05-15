//
//  StoreController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/3/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
import Tabman
import Pageboy
import SideMenu

class OutMainController : TabmanViewController, PageboyViewControllerDataSource {
    private let viewControllers : [UIViewController] = [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc_initial"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc_store")
    ]
    
    var visibleControllerIndex : Int = -1
    
    /* #MARK: Default methods */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeNavigationBarWithSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
        setObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setElements() {
        self.dataSource = self
        self.bar.items = [Item(title: "Inicio"), Item(title: "Tienda")]
        customizeTabBar()
    }
    
    func setObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(viewInitial),
                                       name: .viewInit,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(viewStore),
                                       name: .viewStore,
                                       object: nil)
    }
    
    @objc func viewInitial(_ notification: NSNotification) {
        self.scrollToPage(.at(index: 0 ), animated: false)
    }

    @objc func viewStore(_ notification: NSNotification) {
        self.scrollToPage(.at(index: 1 ), animated: false)
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


