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
    
    func customizeNavigationBar( ) {
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.shadowImage = UIImage()
        var btnsMenu : [UIBarButtonItem] = []
        let btnMenu = UIBarButtonItem(image: UIImage(named: "dwb_pak_menu_button"), style: .plain, target: self, action: #selector(didPressLeftButton))
        btnsMenu.append(btnMenu)
        self.navigationItem.leftBarButtonItems = btnsMenu
    }
    
    func customizeNavigationBarSearch( ) {
        self.navigationController?.navigationBar.topItem?.title = "Resultados de busqueda"
        self.navigationController?.navigationBar.shadowImage = UIImage()

        var btnsMenuRight : [UIBarButtonItem] = []
        let btnMenuRight = UIBarButtonItem(image: UIImage(named: "dwd_pak_box_tittle_bar"), style: .plain, target: self, action: #selector(didPressRightButton))
        btnsMenuRight.append(btnMenuRight)
        self.navigationItem.rightBarButtonItems = btnsMenuRight
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
        
        var btnsMenuRight : [UIBarButtonItem] = []
        let btnMenuRight = UIBarButtonItem(image: UIImage(named: "dwd_pak_box_tittle_bar"), style: .plain, target: self, action: #selector(didPressRightButton))
        btnsMenuRight.append(btnMenuRight)
        self.navigationItem.rightBarButtonItems = btnsMenuRight
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
        searchBar.placeholder = Constants.PLACEHOLDERSB
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        var btnsMenuRight : [UIBarButtonItem] = []
        let btnMenuRight = UIBarButtonItem(image: UIImage(named: "dwd_pak_box_tittle_bar"), style: .plain, target: self, action: #selector(didPressRightButton))
        btnsMenuRight.append(btnMenuRight)
        self.navigationItem.rightBarButtonItems = btnsMenuRight
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let outMainController = self as? OutMainController {
            outMainController.searchWord = searchBar.text!
            outMainController.performSegue(withIdentifier: outMainController.segue_identifier, sender: self)
        }
    }

    @objc func didPressRightButton(_ sender: Any){
        self.performSegue(withIdentifier: "segue_small_box" , sender: self)
    }
    
    @objc func didPressLeftButton (_ sender: Any) {
        if ConstantsModels.UserStatic != nil {
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



