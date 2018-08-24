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
        self.customizeNavigationBarOrders()
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
        //...
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
            appearance.style.background = .solid(color: UtilMethods.hexStringToUIColor(hex: Constants.WHITE))
            appearance.indicator.color = UtilMethods.hexStringToUIColor(hex: Constants.GREEN_PAK)
            
            appearance.layout.itemDistribution = .centered
            appearance.state.color = UIColor(rgb: 0x6D6D6D)
            appearance.state.selectedColor = UIColor(rgb: 0x81D34C)
            appearance.layout.edgeInset = 0.0
            appearance.text.font = UIFont(name: "OpenSans-Light", size: 17)
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
    
    
    func customizeNavigationBarOrders( ) {
        self.navigationController?.navigationBar.shadowImage = UIImage()

        let navView = UIView()
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 25)

        label.text = "  Mis pedidos"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        let image = UIImageView()
        //image.image = UIImage(named: "dwb_pak_button_orders")
        image.image = #imageLiteral(resourceName: "dwb_pak_button_orders_title")
        let imageAspect = image.image!.size.width/image.image!.size.height
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIViewContentMode.scaleAspectFit
        navView.addSubview(label)
        navView.addSubview(image)
        self.navigationItem.titleView = navView
        navView.sizeToFit()
        
       
        if ConstantsModels.count_item == 0 {
            var btnsMenuRight : [UIBarButtonItem] = []
            let btnMenuRight = UIBarButtonItem(image: UIImage(named: "dwd_pak_box_tittle_bar"), style: .plain, target: self, action: #selector(didPressRightButton))
            btnsMenuRight.append(btnMenuRight)
            self.navigationItem.rightBarButtonItems = btnsMenuRight
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
    
    @objc func didPressRightButtonBox(_ sender: Any){
        self.performSegue(withIdentifier: "segue_small_order_box" , sender: self)
    }
    
}
