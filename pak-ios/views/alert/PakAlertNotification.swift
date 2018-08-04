//
//  PakAlertNotification.swift
//  pak-ios
//
//  Created by italo on 13/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//


import Foundation
import SwiftyJSON
import UIKit
import Alamofire
import NVActivityIndicatorView

class PakAlertNotification : UIViewController,NVActivityIndicatorViewable {
    var number : Int = 0
    var val : Int = 0
    
    @IBAction func b_accept(_ sender: Any) {
        self.calification()
    }
    
    @IBOutlet weak var b_s_1: UIButton!
    @IBOutlet weak var b_s_2: UIButton!
    @IBOutlet weak var b_s_3: UIButton!
    @IBOutlet weak var b_s_4: UIButton!
    @IBOutlet weak var b_s_5: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.b_s_1.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        self.b_s_2.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        self.b_s_3.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        self.b_s_4.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        self.b_s_5.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        
        self.b_s_1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        self.b_s_2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        self.b_s_3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        self.b_s_4.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        self.b_s_5.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
//    dwb_estrella_gray
//    dwb_estrella_yellow
//    b_favorites.setImage(UIImage(named: "dwb-ic_favorite_on"), for: .normal)
    @IBAction func b_start_1(_ sender: Any) {
        self.b_s_1.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_2.setImage(UIImage(named: "dwb_estrella_gray"), for: .normal)
        self.b_s_3.setImage(UIImage(named: "dwb_estrella_gray"), for: .normal)
        self.b_s_4.setImage(UIImage(named: "dwb_estrella_gray"), for: .normal)
        self.b_s_5.setImage(UIImage(named: "dwb_estrella_gray"), for: .normal)
        self.val = 1
    }
    
    @IBAction func b_start_2(_ sender: Any) {
        self.b_s_1.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_2.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_3.setImage(UIImage(named: "dwb_estrella_gray"), for: .normal)
        self.b_s_4.setImage(UIImage(named: "dwb_estrella_gray"), for: .normal)
        self.b_s_5.setImage(UIImage(named: "dwb_estrella_gray"), for: .normal)
        self.val = 2
    }
    
    @IBAction func b_start_3(_ sender: Any) {
        self.b_s_1.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_2.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_3.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_4.setImage(UIImage(named: "dwb_estrella_gray"), for: .normal)
        self.b_s_5.setImage(UIImage(named: "dwb_estrella_gray"), for: .normal)
        self.val = 3
    }
    
    
    @IBAction func b_start_4(_ sender: Any) {
        self.b_s_1.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_2.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_3.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_4.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_5.setImage(UIImage(named: "dwb_estrella_gray"), for: .normal)
        self.val = 4
    }
    
    @IBAction func b_start_5(_ sender: Any) {
        self.b_s_1.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_2.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_3.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_4.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.b_s_5.setImage(UIImage(named: "dwb_estrella_yellow"), for: .normal)
        self.val = 5
    }
    
    
    
    func calification() {
        let params: Parameters = ["Numero": ConstantsModels.numberBox,
                                  "Calificacion": val]
        Alamofire.request(URLs.CalificationOrder, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlarmMethods.ReadyCustom(message: "ocurrió un error al realizar la operación. Verifica tu conectividad y vielve a intentarlo", title_message: "¡Oops!", uiViewController: self)

                                LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let _ = JSON(jsonResponse)
                    ConstantsModels.numberBox = 0
                    self.dismiss(animated: false, completion: nil)
                    
                    NotificationCenter.default.post(name: .viewNotificationOut, object: nil, userInfo: nil)
                }
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
                            LoaderMethodsCustom.stopLoaderCustom( uiViewController: self)
        }
    }
    
    
}

