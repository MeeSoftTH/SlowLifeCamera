//
//  SettingViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/8/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 300, height: 200)
        }
        set {
            super.preferredContentSize = newValue
        }
    }

    @IBAction func copyRight(sender: UISwitch) {
        
    }

    @IBAction func time(sender: UISwitch) {
        
    }

    @IBAction func location(sender: UISwitch) {
        
    }
}
