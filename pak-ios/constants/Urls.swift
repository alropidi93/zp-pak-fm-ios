//
//  Urls.swift
//  pak-ios
//
//  Created by Paolo Rossi on 4/25/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
struct URLs {
    private struct Domains {
        static let Dev = "http://pakservice.zp.com.pe"
        static let Release = "http://pakservice.zp.com.pe"
    }
    
    private  struct Routes {
        static let Api = ""
    }
    
    private  static let Domain = Domains.Release
    private  static let Route = Routes.Api
    private  static let BaseURL = Domain + Route
    
    
    static var refreshToken: String { //POST
        return BaseURL + "client/refreshtoken"
    }
    
    static var login: String { //POST
        return BaseURL + "AuthService.svc/Login"
    }
}
