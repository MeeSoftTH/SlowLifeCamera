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
        
        
        userSetting.setObject([1, 10], forKey: "film1")
        userSetting.setObject([2, 10], forKey: "film2")
        userSetting.setObject([3, 10], forKey: "film3")
        userSetting.setObject([4, 10], forKey: "film4")
        
        userSetting.setObject([5, 10], forKey: "film5")
        userSetting.setObject([6, 10], forKey: "film6")
        userSetting.setObject([7, 10], forKey: "film7")
        userSetting.setObject([8, 10], forKey: "film8")
        
        userSetting.setBool(true, forKey : "slot1")
        userSetting.setBool(true, forKey : "slot2")
        userSetting.setBool(true, forKey : "slot3")
        userSetting.setBool(true, forKey : "slot4")
        
    }
    
}