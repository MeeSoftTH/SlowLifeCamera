//
//  File.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 8/10/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

class GlobalFunction {
    
    func createDirectory(slotName: String) {
        var error: NSError?
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(slotName)
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
    }
    
    func createSubDirectory(dir: String, subDir: String) -> String{
        var error: NSError?
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory: AnyObject = paths[0]
        
        var dirPath = documentsDirectory.stringByAppendingPathComponent("\(dir)/\(subDir)" )
        
        var key = subDir
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dirPath)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(dirPath, withIntermediateDirectories: false, attributes: nil, error: &error)
            println("Save by \(dirPath)")
            println("Created folder")
            
        }else {
            for var i = 1; i < 100; i++ {
                
                dirPath = documentsDirectory.stringByAppendingPathComponent("\(dir)/\(subDir)(\(i))")
                key = "\(subDir)(\(i))"
                
                if (!NSFileManager.defaultManager().fileExistsAtPath(dirPath)) {
                    NSFileManager.defaultManager() .createDirectoryAtPath(dirPath, withIntermediateDirectories: false, attributes: nil, error: &error)
                    println("Save by \(dirPath)")
                    println("Created same folder")
                    i = 100
                }
            }
        }
        
        println("Path = \(key)")
        return key
    }
    
    func createSubAndFileDirectory(dir: String, subDir: String, file: String, image: UIImage) {
        
        var error: NSError?
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory: AnyObject = paths[0]
        
        var imagePath = documentsDirectory.stringByAppendingPathComponent("\(dir)/\(subDir)/\(file)")
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(imagePath)) {
            UIImageJPEGRepresentation(image, 1.0).writeToFile("\(imagePath)", atomically: true)
            
            if DataSetting.variable.rowSlected == true {
                DataSetting.variable.myNum = DataSetting.variable.myNum - 1
            }
        }else {
            if DataSetting.variable.isProcess == true {
                var n = 1
                
                while n > 0 {
                    imagePath = "\(imagePath)(\(n))"
                    
                    if (!NSFileManager.defaultManager().fileExistsAtPath(imagePath)) {
                        UIImageJPEGRepresentation(image, 1.0).writeToFile("\(imagePath)", atomically: true)
                        
                        println("Save by \(imagePath)")
                        
                        n = 0
                    }
                }
            }
        }
        
        if (NSFileManager.defaultManager().fileExistsAtPath(imagePath))
        {
            println("FILE AVAILABLE");
            
        }
        else
        {
            println("FILE NOT AVAILABLE");
            
        }
        
    }
}