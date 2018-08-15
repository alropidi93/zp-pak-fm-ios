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
        
        let textFieldInsideSearchBarLabel = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBarLabel?.font = UIFont(name: "OpenSans-Light", size: 15)
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar

        
        
        let smallbox :SmallBoxDC =  PreferencesMethods.getSmallBoxFromOptions()!
        ConstantsModels.count_item = 0
        for element in 0..<smallbox.items.count{
            ConstantsModels.count_item += Int(smallbox.items[element].cant)
        }
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
    
    /* #MARK: Variation of the previous one that permits you back navigation */
    func navigationBarWithSearch() {
        self.navigationController?.navigationBar.topItem?.title = " "
        
        var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = Constants.PLACEHOLDERSB
        
        let textFieldInsideSearchBarLabel = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBarLabel?.font = UIFont(name: "OpenSans-Light", size: 15)
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
       
        
    
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
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            searchBar.isUserInteractionEnabled = true
        }
        
        if let outMainController = self as? MainController {
            outMainController.searchWord = searchBar.text!
            outMainController.performSegue(withIdentifier: outMainController.segue_identifier, sender: self)
        } else if let outMainController = self as? SubCategoriesController {
            outMainController.searchWord = searchBar.text!
            outMainController.performSegue(withIdentifier: outMainController.segue_search_view, sender: self)
        } else if let outMainController = self as? RootCategoriesController {
            outMainController.searchWord = searchBar.text!
            outMainController.performSegue(withIdentifier: outMainController.segue_search_view, sender: self)
        }else if let outMainController = self as? ProductsPerCategoryController {
            outMainController.searchWord = searchBar.text!
            outMainController.performSegue(withIdentifier: outMainController.segue_search_view, sender: self)
        }
    }

    @objc func didPressRightButton(_ sender: Any){
        
        if let button = sender as? UIBarButtonItem {
            button.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                button.isEnabled = true
            }
        }else if let button = sender as? SSBadgeButton {
            button.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                button.isEnabled = true
            }
        }
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



