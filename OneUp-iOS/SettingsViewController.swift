//
//  SettingsViewController.swift
//  OneUp-iOS
//
//  Created by Harris Christiansen on 4/24/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit
import MapKit

class SettingsViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.navigationController?.tabBarItem!.image = UIImage(named:"settings") // Set Tab Bar Icon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}