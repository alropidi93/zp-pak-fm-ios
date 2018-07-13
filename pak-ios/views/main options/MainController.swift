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

class MainController : TabmanViewController, PageboyViewControllerDataSource {
    let segue_identifier : String = "segue_search_view"
    
    var searchWord : String = ""
    var visibleControllerIndex : Int = -1
    
    private let viewControllers : [UIViewController] = [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc_initial"),
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc_store")
    ]
    
    /* #MARK: Default methods */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarWithSearchAndMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            print("yes")
        } else {
            print("no")
            
        }
        setObserversNot()
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
        notificationCenter.addObserver(self, selector: #selector(viewInitial), name: .viewInit, object: nil)
        notificationCenter.addObserver(self, selector: #selector(viewStore), name: .viewStore, object: nil)
        notificationCenter.addObserver(self, selector: #selector(pakAlertNotification), name: .viewNotification, object: nil)

    }
    
    @objc func pakAlertNotification(_ notification: NSNotification) {
       alertDialog(uiViewController: self)
        
    }
    func alertDialog(uiViewController: UIViewController) {
        let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "vc_pak_notification") as! PakAlertNotification
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        uiViewController.present(pakAlert, animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segue_identifier {
            if let vc = segue.destination as? SearchView {
                vc.text = self.searchWord
            }
        }
    }
    func setObserversNot() {
        NotificationCenter.default.addObserver(self, selector: #selector(qualifyStaffFromNotification), name: NSNotification.Name(rawValue: "pedido_entregado"), object: nil)
        
    }
    
    @objc func qualifyStaffFromNotification(_ notification: NSNotification) {
        print("asd")
    }
    
    
    

}
