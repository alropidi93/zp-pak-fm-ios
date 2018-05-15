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


extension UIViewController {
    
   

    func fullKeyboardSupport() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func customizeNavigationBar( ) {
        self.navigationController?.navigationBar.topItem?.title = " "
        var btnsMenu : [UIBarButtonItem] = []
        let btnMenu = UIBarButtonItem(image: UIImage(named: "dwb_pak_menu_button"), style: .plain, target: self, action: #selector(didPressLeftButton))
        btnsMenu.append(btnMenu)
        self.navigationItem.leftBarButtonItems = btnsMenu
        
        
    }
    
    
    func customizeNavigationBarWithSearch() {
        self.navigationController?.navigationBar.topItem?.title = " "
        var btnsMenu : [UIBarButtonItem] = []
        let btnMenu = UIBarButtonItem(image: UIImage(named: "dwb_pak_menu_button"), style: .plain, target: self, action: #selector(didPressLeftButton))
        btnsMenu.append(btnMenu)
        self.navigationItem.leftBarButtonItems = btnsMenu
        
        
        var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar

        var btnsMenuRight : [UIBarButtonItem] = []
        let btnMenuRight = UIBarButtonItem(image: UIImage(named: "dwd_pak_box_tittle_bar"), style: .plain, target: self, action: nil)
        btnsMenuRight.append(btnMenuRight)
        self.navigationItem.rightBarButtonItems = btnsMenuRight


    }
    
    
    @objc func didPressLeftButton (_ sender: Any){
        if UserMethods.getUserFromOptions() != nil {
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
