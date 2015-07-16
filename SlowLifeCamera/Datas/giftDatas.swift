//
//  giftDatas.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/15/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class giftDatas {
    func setting() {
        
        let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
        
        userSetting.setInteger(100, forKey: "myCoins")
        
        
        userSetting.setObject(["normal", 10], forKey: "film1")
        userSetting.setObject(["normal", 10], forKey: "film2")
        userSetting.setObject(["normal", 10], forKey: "film3")
        userSetting.setObject(["normal", 10], forKey: "film4")
        
        userSetting.setBool(true, forKey : "slot1")
        userSetting.setBool(true, forKey : "slot2")
        userSetting.setBool(true, forKey : "slot3")
        userSetting.setBool(true, forKey : "slot4")
        
    }
    
}