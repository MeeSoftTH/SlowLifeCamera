//
//  FilterViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/21/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

protocol removeFilm {
    func removeAfterSuccess(isTrue: Bool)
}

let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")

class FilterViewController: UIViewController {
    
    @IBOutlet var GaleryView: UIView!
    @IBOutlet var processView: UIView!
    
    var delegate: removeFilm? = nil
    
    var keySlot = String()
    var keyFilter = String()
    
    let showCopy = userSetting.boolForKey("showCopyRight")
    let showTime = userSetting.boolForKey("ShowTime")
    let showLocation = userSetting.boolForKey("showLocation")
    
    
    let context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        delay(5.0){
            self.processFilter()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func processFilter() {
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        var fileList = listFilesFromDocumentsFolder()
        
        let count = fileList.count
        var isDir:Bool = true;
        
        
        if count > 0 {
            var filterName = "CCtrlFilter"
            var iconName = "filter1"
            
            let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            
            let documentsDirectory: AnyObject = dir[0]
            
            for var i:Int = 0; i < count; i++
            {
                if fileManager.fileExistsAtPath(fileList[i]) != true
                {
                    println("File is \(fileList[i])")
                    
                    var getImagePath = documentsDirectory.stringByAppendingPathComponent("RawData/\(self.keySlot)/\(fileList[i])")
                    
                    var fileURL = NSURL(fileURLWithPath: getImagePath)
                    
                    if keyFilter == "#01" {
                        ApplyCCtrlFilter(fileURL!, rename: fileList[i])
                        filterName = "CCtrlFilter"
                        iconName = "filter1"
                        
                    }else if keyFilter == "#02" {
                        ApplySepiaFilter(fileURL!, rename: fileList[i])
                        filterName = "SepiaFilter"
                        iconName = "filter2"
                        
                    }else if keyFilter == "#03" {
                        ApplyReduceNoiseFilter(fileURL!, rename: fileList[i])
                        filterName = "ReduceNoiseFilter"
                        iconName = "filter3"
                        
                    }else if keyFilter == "#04" {
                        ApplyMonoFilter(fileURL!, rename: fileList[i])
                        filterName = "MonoFilter"
                        iconName = "filter4"
                        
                    }else if keyFilter == "#05" {
                        ApplyPolyFilter(fileURL!, rename: fileList[i])
                        filterName = "PolyFilter"
                        iconName = "filter5"
                        
                    }else if keyFilter == "#06" {
                        ApplyFadeFilter(fileURL!, rename: fileList[i])
                        filterName = "FadeFilter"
                        iconName = "filter6"
                        
                    }else if keyFilter == "#07" {
                        ApplyNormalFilter(fileURL!, rename: fileList[i])
                        filterName = "NormalFilter"
                        iconName = "filter7"
                        
                    }else if keyFilter == "#08" {
                        ApplySmallFilter(fileURL!, rename: fileList[i])
                        filterName = "SmallFilter"
                        iconName = "filter8"
                        
                    }
                    
                    removeFile(fileList[i])
                }
            }
            
            var intCoins: Int = userSetting.integerForKey("myCoins")
            
            intCoins = intCoins + save.variable.filterSuccess
            
            userSetting.setInteger(intCoins, forKey: "myCoins")
            
            var numberOfPhoto = String(save.variable.filterSuccess)
            
            userSetting.setObject([self.keySlot, filterName, iconName, numberOfPhoto], forKey: self.keySlot)
            
            userSetting.setObject(["", "", "", 10, false], forKey: save.variable.key)
            
            save.variable.filterSuccess = 0
            
            println("Set to key = \(self.keySlot)")
            println("New datas \(userSetting.objectForKey(self.keySlot))")
            
            processView.hidden = true
            GaleryView.hidden = false
            
            self.delegate?.removeAfterSuccess(true)
            
        }else {
            println("No photo")
        }
    }
    
    func listFilesFromDocumentsFolder() -> [String]
    {
        var theError = NSErrorPointer()
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if dirs != nil {
            println("This slot = \(self.keySlot)")
            let dir = dirs![0]
            let fileList = NSFileManager.defaultManager().contentsOfDirectoryAtPath("\(dir)/RawData/\(self.keySlot)", error: theError)
            println("this dir = \(fileList)")
            return fileList as! [String]
        }else{
            let fileList = [""]
            return fileList
        }
    }
    
    
    func removeFile(path: String) {
        let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory: AnyObject = dir[0]
        
        var imagePath = documentsDirectory.stringByAppendingPathComponent("RawData/\(self.keySlot)/\(path)")
        
        let filemgr = NSFileManager.defaultManager()
        var error: NSError?
        
        if filemgr.removeItemAtPath(imagePath, error: &error) {
            println("\(imagePath) = Remove successful")
        } else {
            println("Remove failed: \(error!.localizedDescription)")
        }
        return
    }
    
    func ApplyCCtrlFilter(fileURL:NSURL, rename: String) {
        let filter = CIFilter(name: "CIColorControls")
        let ciImage = CIImage(contentsOfURL: fileURL)
        
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.92, forKey: kCIInputSaturationKey)
        filter.setValue(0.98, forKey: kCIInputContrastKey)
        //let context = CIContext(options:nil)
        
        // 2
        let cgimg = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        // 3
        let newImage = UIImage(CGImage: cgimg)
        self.moveFile(newImage!, newName: rename)
        
    }
    
    func ApplySepiaFilter(fileURL:NSURL, rename: String) {
        let filter = CIFilter(name: "CISepiaTone")
        let ciImage = CIImage(contentsOfURL: fileURL)
        
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.87, forKey: kCIInputIntensityKey)
        
        //let context = CIContext(options:nil)
        
        // 2
        let cgimg = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        // 3
        let newImage = UIImage(CGImage: cgimg)
        self.moveFile(newImage!, newName: rename)
    }
    
    func ApplyReduceNoiseFilter(fileURL:NSURL, rename: String) {
        let filter = CIFilter(name: "CISharpenLuminance")
        let ciImage = CIImage(contentsOfURL: fileURL)
        
        //filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.97, forKey: kCIInputSharpnessKey)
        
        let filter2 = CIFilter(name: "CIBloom")
        
        //filter2.setDefaults()
        filter2.setValue(filter.outputImage, forKey: kCIInputImageKey)
        filter2.setValue(0.58, forKey: kCIInputIntensityKey)
        filter2.setValue(4, forKey: kCIInputRadiusKey)
        
        //let context = CIContext(options:nil)
        
        // 2
        let cgimg2 = context.createCGImage(filter2.outputImage, fromRect: filter2.outputImage.extent())
        
        // 3
        let newImage2 = UIImage(CGImage: cgimg2)
        self.moveFile(newImage2!, newName: rename)
    }
    
    func ApplyMonoFilter(fileURL:NSURL, rename: String) {
        //CIMaximumComponent
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIMaximumComponent")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let newImage = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent()))
        self.moveFile(newImage!, newName: rename)
    }
    
    func ApplyPolyFilter(fileURL:NSURL, rename: String) {
        //CIColorCrossPolynomial
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CISharpenLuminance")
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        //filter.setValue(0.87, forKey: kCIInputIntensityKey)
        
        let filter2 = CIFilter(name: "CIColorCrossPolynomial")
        
        let floatArr: [CGFloat] = [0,1,0.8,0,-1,-4,0,40,0]
        var vector = CIVector(values: floatArr, count: floatArr.count)
        
        filter2.setDefaults()
        filter2.setValue(filter.outputImage, forKey: kCIInputImageKey)
        filter2.setValue(vector, forKey: "inputGreenCoefficients")
        
        let newImage = UIImage(CGImage: context.createCGImage(filter2.outputImage, fromRect: filter2.outputImage.extent()))
        self.moveFile(newImage!, newName: rename)
        
    }
    
    func ApplyFadeFilter(fileURL:NSURL, rename: String) {
        //CIPhotoEffectFade
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIPhotoEffectFade")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let newImage = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent()))
        self.moveFile(newImage!, newName: rename)
    }
    
    func ApplyNormalFilter(fileURL:NSURL, rename: String) {
        //CIColorCrossPolynomial
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CISharpenLuminance")
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        //filter.setValue(0.87, forKey: kCIInputIntensityKey)
        
        let filter2 = CIFilter(name: "CIColorCrossPolynomial")
        
        let floatArr: [CGFloat] = [0,1,0.8,0,-1,-4,0,40,0]
        var vector = CIVector(values: floatArr, count: floatArr.count)
        
        filter2.setDefaults()
        filter2.setValue(filter.outputImage, forKey: kCIInputImageKey)
        filter2.setValue(vector, forKey: "inputGreenCoefficients")
        
        let newImage = UIImage(CGImage: context.createCGImage(filter2.outputImage, fromRect: filter2.outputImage.extent()))
        self.moveFile(newImage!, newName: rename)
        
    }
    
    func ApplySmallFilter(fileURL:NSURL, rename: String) {
        //CIPhotoEffectFade
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIPhotoEffectFade")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let newImage = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent()))
        self.moveFile(newImage!, newName: rename)
    }
    
    
    func moveFile(image: UIImage, newName: String) {
        initial().createSubDirectory("CompletedData", subDir: keySlot)
        var currentFileName: String = "affterFilter_\(newName)"
        println(currentFileName)
        
        var imageUI = UIImage(CGImage: image.CGImage, scale: CGFloat(1.0), orientation: UIImageOrientation.Right)
        
        initial().createSubAndFileDirectory("CompletedData", subDir: keySlot, file: currentFileName, image: imageUI!)
        
        save.variable.filterSuccess += 1
        
    }
    
}
