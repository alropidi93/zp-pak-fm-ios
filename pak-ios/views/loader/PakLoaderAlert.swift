//
//  PakLoaderAlert.swift
//  pak-ios
//
//  Created by inf227adm on 19/07/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation
import UIKit

class PakLoaderAlerto : UIViewController {



    @IBOutlet weak var iv_loader_image: UIImageView!



    override func viewDidAppear(_ animated: Bool) {


    }
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animate(withDuration: 2, animations: {
            self.iv_loader_image.transform = CGAffineTransform(rotationAngle: (-45))

        }){_ in
            UIView.animateKeyframes(withDuration: 1.0, delay: 0.25, options: [.repeat,.autoreverse], animations: {
                self.iv_loader_image.transform = CGAffineTransform(rotationAngle: (45))
            })}
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }


    func stopLoader()
    {

        self.dismiss(animated: true, completion: nil)

    }



}
