//
//  InitialController.swift
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
import Agrume
import PlayerKit

class InitialController : UIViewController , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    private let segue_identifier = "segue_splash_login"
    private let reuse_advertisement = "cvc_advertisement"
    private let reuse_placeholder = "cvc_placeholder"

    @IBOutlet weak var cv_advertisement: UICollectionView!
    
    private var allItems : [Ads] = []
    
    //#MARK: Common functions
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AMD: \(String(describing: type(of: self)))")
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        
//
//    }
    func setElements() {
        self.cv_advertisement.delegate = self
        self.cv_advertisement.dataSource = self
        

        self.getAds()
    }
    
    // #MARK: Tableview controller
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allItems.count == 0 ? (1) : (self.allItems.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.allItems.count == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_placeholder, for: indexPath) as! CVCPlaceholder
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuse_advertisement, for: indexPath) as! CVCAdvertisement
        if self.allItems[indexPath.row].type == "V" { // Videos
            cell.advertisement_image?.image = self.allItems[indexPath.row].thumbnail
            cell.iv_play.isHidden = false
        } else { // Images
            UtilMethods.setImage(imageview: cell.advertisement_image!, imageurl: self.allItems[indexPath.row].archive, placeholderurl: "")
            cell.iv_play.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CVCAdvertisement
        if self.allItems.item(at: indexPath.row)?.type == "V" { // Videos
            let videoURL = URL(string: (allItems.item(at: indexPath.row)?.archive)!)
            let player = AVPlayer(url: videoURL!)
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = player
            present(videoPlayer,animated:true,completion:{
                player.play()
            }
            )
        } else { // Images
            let agrume = Agrume(image: (cell.advertisement_image?.image)!, background: .colored(.black))
            agrume.show(from: self)
        }
    }
    
    //Perfectly fit collection (all screens)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let itemWidth = (collectionView.bounds.size.width - marginsAndInsets).rounded(.down)
        return CGSize(width: itemWidth, height: 250)
    }
    
    // #MARK: Get data from web services
    func getAds() {
        
        Alamofire.request(URLs.GetAds, method: .get , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {

                AlarmMethods.ReadyCustom(message: "Ocurrió un error al realizar la operación. Verifica tu conectividad y vuelve a intentarlo", title_message: "¡Oops!", uiViewController: self)
                 

                return
            }
            let statusCode = response.response!.statusCode
            if statusCode == 200 {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    if jsonResult["Msg"] == "OK"{
                        self.allItems = []
                        for ( _ , element) in jsonResult["Anuncios"] {
                            let ads  = Ads(element)
                            self.allItems.append(ads)
                        }
                        self.cv_advertisement.reloadData()
                    }
                }
                 
            } else {
                if let jsonResponse = response.result.value {
                    let jsonResult = JSON(jsonResponse)
                    AlarmMethods.errorWarning(message:  jsonResult["Msg"].string!, uiViewController: self)
                } else {
                    AlamoMethods.defaultError(self)
                }
            }
            print("HOLA")
             
        }
    }
}
