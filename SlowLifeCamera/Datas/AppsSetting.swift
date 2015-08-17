//
//  initial.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/15/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//


class AppSetting {
    func setting() {
        let userSetting: NSUserDefaults! = NSUserDefaults.standardUserDefaults()
        
        userSetting.setInteger(100, forKey: "myCoins")
        userSetting.setBool(true, forKey : "isFirstUse")
        
        // defind Object [dirId, filterId, iconName, filmCount, isOn,, key]
        
        userSetting.setObject(["Slot1", DataSetting.variable.filterCode1, DataSetting.variable.iconFilter1, DataSetting.variable.numberFilter1, DataSetting.variable.numberFilter1, true], forKey: "row1")
        userSetting.setObject(["Slot2", DataSetting.variable.filterCode2, DataSetting.variable.iconFilter2, DataSetting.variable.numberFilter2, DataSetting.variable.numberFilter2, true], forKey: "row2")
        userSetting.setObject(["Slot3", DataSetting.variable.filterCode3, DataSetting.variable.iconFilter3, DataSetting.variable.numberFilter3, DataSetting.variable.numberFilter3, true], forKey: "row3")
        userSetting.setObject(["Slot4", DataSetting.variable.filterCode4, DataSetting.variable.iconFilter4, DataSetting.variable.numberFilter4, DataSetting.variable.numberFilter4, true], forKey: "row4")
        
        userSetting.setObject(["Slot5", "", "", 0, 0,  false], forKey: "row5")
        userSetting.setObject(["Slot6", "", "", 0, 0, false], forKey: "row6")
        userSetting.setObject(["Slot7", "", "", 0, 0, false], forKey: "row7")
        userSetting.setObject(["Slot8", "", "", 0, 0, false], forKey: "row8")
        
        // completed photo
        // defind folderName, FilterName, iconName, numPhoto
        userSetting.setObject(["", "", "", ""], forKey: "Slot1")
        userSetting.setObject(["", "", "", ""], forKey: "Slot2")
        userSetting.setObject(["", "", "", ""], forKey: "Slot3")
        userSetting.setObject(["", "", "", ""], forKey: "Slot4")
        
        userSetting.setObject(["", "", "", ""], forKey: "Slot5")
        userSetting.setObject(["", "", "", ""], forKey: "Slot6")
        userSetting.setObject(["", "", "", ""], forKey: "Slot7")
        userSetting.setObject(["", "", "", ""], forKey: "Slot8")
        
        userSetting.setBool(true, forKey : "showCopyRight")
        userSetting.setBool(true, forKey : "showFrame")
        userSetting.setBool(true, forKey : "ShowTime")
        userSetting.setBool(false, forKey : "showLocation")
        
        GlobalFunction().createDirectory("RawData")
        GlobalFunction().createDirectory("CompletedData")
    }
}