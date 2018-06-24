//
//  PageObservation.swift
//  pak-ios
//
//  Created by Paolo Rossi on 6/19/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
protocol PageObservation: class {
    func getParentPageViewController(parentRef: AlertPageVc)
}
