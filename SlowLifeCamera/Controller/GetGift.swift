//
//  GetGift.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/16/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class GetGift: UIViewController {
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getgift(sender: UIButton) {
        var intCoins: Int = userSetting.integerForKey("myCoins")
        
        intCoins = intCoins + 50
        
        userSetting.setInteger(intCoins, forKey: "myCoins")
        
        var dateFormatter = NSDateFormatter()
        let date = NSDate()
        
        userSetting.setObject(date, forKey: "lasttime")
        
        navigationController!.popViewControllerAnimated(true)
    }
}