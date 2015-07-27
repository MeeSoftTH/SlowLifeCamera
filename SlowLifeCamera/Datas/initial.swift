//
//  initial.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/15/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class initial {
    func initial() {
        let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
        
        userSetting.setInteger(100, forKey: "myCoins")
        userSetting.setBool(true, forKey : "isFirstUse")
        
        // defind Object [dirId, filterId, iconName, filmCount, isOn,, key]
        
        userSetting.setObject(["Slot1", "#01", "filter1", 25, true], forKey: "row1")
        userSetting.setObject(["Slot2", "#02", "filter2", 25, true], forKey: "row2")
        userSetting.setObject(["Slot3", "#03", "filter3", 25, true], forKey: "row3")
        userSetting.setObject(["Slot4", "#04", "filter4", 25, true], forKey: "row4")
        
        userSetting.setObject(["Slot5", "", "", 25, false], forKey: "row5")
        userSetting.setObject(["Slot6", "", "", 25, false], forKey: "row6")
        userSetting.setObject(["Slot7", "", "", 25, false], forKey: "row7")
        userSetting.setObject(["Slot8", "", "", 25, false], forKey: "row8")
        
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
        //userSetting.setBool(true, forKey : "ShowTime")
        //userSetting.setBool(true, forKey : "showLocation")
        
        createDirectory("RawData")
        createDirectory("CompletedData")
        
    }
    
    func createDirectory(slotName: String) {
        var error: NSError?
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(slotName)
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
    }
    
    func createSubDirectory(dir: String, subDir: String) {
        var error: NSError?
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory: AnyObject = paths[0]
        
        var dirPath = documentsDirectory.stringByAppendingPathComponent("\(dir)/\(subDir)" )
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dirPath)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(dirPath, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
        
        //println("Path = \(dirPath)")
    }
    
    func createSubAndFileDirectory(dir: String, subDir: String, file: String, image: UIImage) {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory: AnyObject = paths[0]
        
        var imagePath = documentsDirectory.stringByAppendingPathComponent("\(dir)/\(subDir)/\(file)")
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(imagePath)) {
            UIImageJPEGRepresentation(image, 100).writeToFile(imagePath, atomically: true)
            
        }
    }
}