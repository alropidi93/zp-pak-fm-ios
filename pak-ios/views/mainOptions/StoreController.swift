//
//  StoreController.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/3/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import AVFoundation
import SwiftyJSON
import UIKit
import Alamofire
import AVKit
import NVActivityIndicatorView



class StoreController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,NVActivityIndicatorViewable,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var cv_categories: UICollectionView!
    
    private let reuse_identifier = "cvc_category"
    private var items : [CategoriesDC] = []
    
    //#MARK: Common methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements() {
        self.cv_categories.delegate = self
        self.cv_categories.dataSource = self
        getCategories()
    }

    //#MARK: Collectionview methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_identifier, for: indexPath) as! CVCCategory
        cell.l_name_category.text = self.items[indexPath.item].name
        UtilMethods.setImage(imageview: cell.iv_category, imageurl: self.items[indexPath.item].img, placeholderurl: "dwb-pak-logo")
        return cell
    }
    //Perfectly fit collection (all screens)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let itemWidth = (collectionView.bounds.size.width - marginsAndInsets).rounded(.down)
        return CGSize(width: itemWidth, height: 200)
    }
    
    
    
    
    
    
    func getCategories() {
        
        let user = PreferencesMethods.getUserFromOptions()
        var params : Parameters
        if user != nil  {
            let idUser  :UInt64 = (PreferencesMethods.getUserFromOptions()?.idUser)!
            params = [ "IdUsuario": idUser]
        } else {
            params = [ : ]
        }
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        
        Alamofire.request(URLs.GetCategories, method: .post ,parameters: params , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
                return
            }
            let statusCode = response.response!.statusCode
            print(statusCode)
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        self.items = []
                        for ( _ , element) in jsonResult["Categorias"] {
                            let category  = CategoriesDC(element)
                            self.items.append(category)
                        }
                        self.cv_categories.reloadData()
                    }
                }
            } else {
                print("hopa1")
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["message"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            self.stopAnimating()
        }
    }
    

}
