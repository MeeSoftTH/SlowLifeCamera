//
//  SettingViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/8/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    let userSetting: NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var showCopy: UISwitch!
    @IBOutlet var showTime: UISwitch!
    @IBOutlet var showLocation: UISwitch!
    @IBOutlet var showFrame: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showCopy.setOn(userSetting.boolForKey("showCopyRight"), animated:true)
        showFrame.setOn(userSetting.boolForKey("showFrame"), animated:true)
        showTime.setOn(userSetting.boolForKey("ShowTime"), animated:true)
       //showLocation.setOn(userSetting.boolForKey("showLocation"), animated:true)
     
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        println("done")
    }

    @IBAction func copyRight(sender: UISwitch) {
        if showCopy.on {
            userSetting.setBool(true, forKey : "showCopyRight")
        }else {
            userSetting.setBool(false, forKey : "showCopyRight")
        }
    }
    
    
    @IBAction func frme(sender: UISwitch) {
        if showFrame.on {
            userSetting.setBool(true, forKey : "showFrame")
        }else {
            userSetting.setBool(false, forKey : "showFrame")
        }
    }

    @IBAction func time(sender: UISwitch) {
        if showTime.on {
            userSetting.setBool(true, forKey : "ShowTime")
        }else {
            userSetting.setBool(false, forKey : "ShowTime")
        }
    }

    /*@IBAction func location(sender: UISwitch) {
        if showLocation.on {
            userSetting.setBool(true, forKey : "showLocation")
        }else {
            userSetting.setBool(false, forKey : "showLocation")
        }
    }*/
}
