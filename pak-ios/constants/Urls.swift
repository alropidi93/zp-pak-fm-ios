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
        static let Dev = "http://pakservice.zp.com.pe/"
        static let Release = "http://pakservice.zp.com.pe/"
    }
    
    private  struct Routes {
        static let Api = ""
    }
    
    private  static let Domain = Domains.Release
    private  static let Route = Routes.Api
    private  static let BaseURL = Domain + Route
    static let MultimediaAnuncioURL = "http://pakadmin.zp.com.pe/Images/Anuncios/"
    static let MultimediaCategoriasURL = "http://pakadmin.zp.com.pe/Images/Categorias/"
    static let MultimediaProductosURL = "http://pakadmin.zp.com.pe/Images/Products/"

    
    static var refreshToken: String { //POST
        return BaseURL + "client/refreshtoken"
    }
    
    static var login: String { //POST
        return BaseURL + "AuthService.svc/Login"
    }
    
    static var ListDistrict: String { //GET
        return BaseURL + "AuthService.svc/ListarDistritos"
    }
    
    static var SignUp: String { //Post
        return BaseURL + "AuthService.svc/RegistrarUsuario"
    }
    
    
    
    
    
    // CAJITA
    static var GetGUID: String { //POST
        return BaseURL + "OrderService.svc/ObtenerCajita"
    }
    static var AddItemABox: String { //POST
        return BaseURL + "OrderService.svc/AgregarItemCajita"
    }
    
    static var ModifySmallBox: String { //POST
        return BaseURL + "OrderService.svc/ModificarItemCajita"
    }
    //ANUNCIOS
    static var GetAds: String { //GET
        return BaseURL + "AdService.svc/ListarAnuncios"
    }
    //STORE
    static var GetCategories: String { //GET
        return BaseURL + "CatalogService.svc/listarCategorias"
    }
    
    static var SearchProduct: String { //POST
        return BaseURL + "CatalogService.svc/BuscarProductos"
    }
    //Customer
    static var AddOrEliminiteFavoritie: String { //POST
        return BaseURL + "CustomerService.svc/AgregarQuitarFavorito"
    }
    static var ListFavoritie: String { //POST
        return BaseURL + "CustomerService.svc/ListarFavoritos"
    }
    static var RegisterInvitationCode: String { //POST
        return BaseURL + "CustomerService.svc/RegistrarCodigoInvitacion"
    }
    static var ListDiscount: String { //POST
        return BaseURL + "CustomerService.svc/ListarDescuentos"
    }
    
    
    
}
