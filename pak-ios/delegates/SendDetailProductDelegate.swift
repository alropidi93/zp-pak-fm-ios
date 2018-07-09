//
//  SendDetailProduct.swift
//  pak-ios
//
//  Created by inf227al on 9/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation

protocol SendDetailProductDelegate {
    func okButtonTapped(_ product: ProductDC)
    func addProduct(_ product: ProductDC)
}
