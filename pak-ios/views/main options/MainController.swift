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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarWithSearchAndMenu()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        
        let ivBackground = UIImageView();
        // amd - New single background for all tabs
        ivBackground.image = UIImage(named: "dwb_pak_background_loby_amd")
        ivBackground.contentMode = .scaleAspectFill
        ivBackground.frame = self.view.frame
        self.view.addSubview(ivBackground)
        self.view.sendSubview(toBack: ivBackground)
        
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
        notificationCenter.addObserver(self, selector: #selector(pakAlertLogueOut), name: .viewLogueout, object: nil)
        notificationCenter.addObserver(self, selector: #selector(pakAlertNotificationOut), name: .viewNotificationOut, object: nil)
        //amd agregar un observer
        
        notificationCenter.addObserver(self, selector: #selector(pakAlertProximo), name: .viewProximo, object: nil)
        

    }
    
    @objc func pakAlertLogueOut(_ notification: NSNotification) {
        alertDialogLogueOut(uiViewController: self)
    }
    @objc func pakAlertNotificationOut(_ notification: NSNotification) {
        AlarmMethods.ReadyCustom(message: "Muchas gracias por calificar nuestros servicio.", title_message: "¡Listo!", uiViewController: self)
    }
    
    func alertDialogLogueOut(uiViewController: UIViewController) {
        let pakAlert = uiViewController.storyboard?.instantiateViewController(withIdentifier: "alert_logueout") as! PakAlertLogueout
        pakAlert.definesPresentationContext = true
        pakAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pakAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        uiViewController.present(pakAlert, animated: true, completion: nil)
    }
    
    @objc func pakAlertNotification(_ notification: NSNotification) {
        alertDialog(uiViewController: self)
        
    }
    
    
    @objc func pakAlertProximo(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        
        print(userInfo!["cliente"] as? String ?? "_cliente")
        print(userInfo!["horaInicio"] as? String ?? "_horaInicio")
        print(userInfo!["horaFin"] as? String ?? "_horaFin")
        
        let cliente = userInfo!["cliente"] as? String ?? "_cliente"
        let horaInicio = userInfo!["horaInicio"] as? String ?? "_horaInicio"
        let horaFin = userInfo!["horaFin"] as? String ?? "_horaFin"
        let horario = "\(horaInicio) - \(horaFin)"
        
        let title = "¡Hola \(cliente)!"
        let text = "Recuerda que mañana te estaremos enviando tu pedido entre el horario de \(horario)"
        AlarmMethods.ReadyCustom(message: text, title_message: title, uiViewController: self)
        
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
            appearance.state.color = UIColor(rgb: 0x6D6D6D)
            appearance.state.selectedColor = UIColor(rgb: 0x81D34C)
            appearance.layout.edgeInset = 0.0
            appearance.text.font = UIFont(name: "OpenSans-Light", size: 15)
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
