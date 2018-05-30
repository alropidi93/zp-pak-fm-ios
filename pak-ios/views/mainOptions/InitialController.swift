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

class InitialController : UIViewController , UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {
    
    private let segue_identifier = "segue_splash_login"
    
    
    @IBOutlet weak var tv_publicity: UITableView!
    
    private let reuse_question = "tvc_publicity_image"
    private let reuse_placeholder = "tvc_placeholder"
    
    private var allItems : [Ads] = []
    
    
    
    //#MARK: Common functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setElements(){
        self.tv_publicity.delegate = self
        self.tv_publicity.dataSource = self
        self.getAds()
    }
    
    // #MARK: Tableview controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allItems.count == 0 ? (1) : (self.allItems.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.allItems.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: self.reuse_placeholder, for: indexPath as IndexPath) as! TVCPlaceholder
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuse_question, for: indexPath as IndexPath) as! TVCPublicityImage
        if self.allItems[indexPath.row].type == "V" { // Videos
            cell.iv_publicity_image?.image = self.allItems[indexPath.row].thumbnail
        } else { // Images
            UtilMethods.setImage(imageview: cell.iv_publicity_image!, imageurl: self.allItems[indexPath.row].archive, placeholderurl: "dwb_pak_button_info")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TVCPublicityImage
        if self.allItems.item(at: indexPath.row)?.type == "V" { // Videos
           
          
            
            let videoURL = URL(string: (allItems.item(at: indexPath.row)?.archive)!)
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            
            self.view.layer.addSublayer(playerLayer)
            player.play()


        } else { // Images
            
            let agrume = Agrume(image: (cell.iv_publicity_image?.image)!, backgroundColor: UIColor.black)
            agrume.showFrom(self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(250.0)
    }
    
    // #MARK: Get data from web services
    func getAds() {
        self.startAnimating(CGSize(width: 150, height: 150), message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballRotateChase.rawValue)!)
        Alamofire.request(URLs.GetAds, method: .get , encoding: JSONEncoding.default).responseJSON { response in
            if response.response == nil {
                AlamoMethods.connectionError(uiViewController: self)
                self.stopAnimating()
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
                        self.tv_publicity.reloadData()
                    }
                }
            } else {
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


