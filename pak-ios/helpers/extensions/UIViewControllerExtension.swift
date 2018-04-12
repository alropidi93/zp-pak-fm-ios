//
//  UIViewControllerExtension.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/11/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func fullKeyboardSupport() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func customizeNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "dwb_kinephy_logo"))
        var btnsMenu : [UIBarButtonItem] = []
        let btnMenu = UIBarButtonItem(image: UIImage(named: "ic_adidas_small_black"), style: .plain, target: self, action: nil)
        btnsMenu.append(btnMenu)
        self.navigationItem.rightBarButtonItems = btnsMenu
    }
}
