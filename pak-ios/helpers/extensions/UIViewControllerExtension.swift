//
//  UIViewControllerExtension.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/11/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

extension UIViewController : UISearchBarDelegate {
    func fullKeyboardSupport() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
 
    func customizeNavigationBarFavourite( ) {
        self.navigationController?.navigationBar.shadowImage = UIImage()

        let navView = UIView()
        let label = UILabel()
        label.text = "  Mis Favoritos"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        let image = UIImageView()
        image.image = UIImage(named: "dwb_pak_button_favorites")
        let imageAspect = image.image!.size.width/image.image!.size.height
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIViewContentMode.scaleAspectFit
        navView.addSubview(label)
        navView.addSubview(image)
        self.navigationItem.titleView = navView
        navView.sizeToFit()
        
        let notificationButton = SSBadgeButton()
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "dwd_pak_box_tittle_bar")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 45)
        notificationButton.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
        notificationButton.badge = "\(PreferencesMethods.getSmallBoxFromOptions()?.items.count ?? 0) "
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
    }
    
    /* #MARK: This element lets you find some stuff from the total offered products */
    func navigationBarWithSearchAndMenu() {
        self.navigationController?.navigationBar.topItem?.title = " "
        var btnsMenu : [UIBarButtonItem] = []
        let btnMenu = UIBarButtonItem(image: UIImage(named: "dwb_pak_menu_button"), style: .plain, target: self, action: #selector(didPressLeftButton))
        btnsMenu.append(btnMenu)
        self.navigationItem.leftBarButtonItems = btnsMenu
        
        var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = Constants.PLACEHOLDERSB
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        let notificationButton = SSBadgeButton()
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "dwd_pak_box_tittle_bar")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 45)
        notificationButton.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
        
        let smallbox :SmallBoxDC =  PreferencesMethods.getSmallBoxFromOptions()!
        ConstantsModels.count_item = 0
        for element in 0..<smallbox.items.count{
            ConstantsModels.count_item += Int(smallbox.items[element].cant)
        }
        notificationButton.badge = "\(ConstantsModels.count_item) "
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
    }
    
    /* #MARK: Variation of the previous one that permits you back navigation */
    func navigationBarWithSearch() {
        self.navigationController?.navigationBar.topItem?.title = " "
        
        var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = Constants.PLACEHOLDERSB
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        let notificationButton = SSBadgeButton()
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "dwd_pak_box_tittle_bar")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 45)
        notificationButton.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
        notificationButton.badge = "\(ConstantsModels.count_item) "
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
    }
    
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let outMainController = self as? MainController {
            outMainController.searchWord = searchBar.text!
            outMainController.performSegue(withIdentifier: outMainController.segue_identifier, sender: self)
        } else if let outMainController = self as? SubCategoriesController {
            outMainController.searchWord = searchBar.text!
            outMainController.performSegue(withIdentifier: outMainController.segue_search_view, sender: self)
        } else if let outMainController = self as? RootCategoriesController {
            outMainController.searchWord = searchBar.text!
            outMainController.performSegue(withIdentifier: outMainController.segue_search_view, sender: self)
        }
    }

    @objc func didPressRightButton(_ sender: Any){
        self.performSegue(withIdentifier: "segue_small_box" , sender: self)
    }
    
    @objc func didPressLeftButton (_ sender: Any) {
        if ConstantsModels.static_user != nil {
            self.performSegue(withIdentifier: "segue_side_menu_in" , sender: self)
            SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "InMenuNavigationController") as? UISideMenuNavigationController
        } else {
            self.performSegue(withIdentifier: "segue_side_menu_out" , sender: self)
            SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "OutMenuNavigationController") as? UISideMenuNavigationController
        }
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = view.frame.width * CGFloat(0.8)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension UIViewController: UISideMenuNavigationControllerDelegate {
    public func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    public func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    public func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    public func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}



