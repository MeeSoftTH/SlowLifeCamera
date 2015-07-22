//
//  FilterViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/21/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    @IBOutlet var GaleryView: UIView!
    @IBOutlet var processView: UIView!
    
    var keySlot = String()
    var keyFilter = String()
    let context = CIContext(options: nil)
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressLabel.text = "0%"
        
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
            var filterName = ""
            var iconName = ""
            
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
                        ApplyCCtrlFilter(fileURL!)
                        var filterName = "CCtrlFilter"
                        var iconName = "filter1"
                        
                    }else if keyFilter == "#02" {
                         ApplySepiaFilter(fileURL!)
                        var filterName = "SepiaFilter"
                        var iconName = "filter2"

                    }else if keyFilter == "#03" {
                         ApplyReduceNoiseFilter(fileURL!)
                        var filterName = "ReduceNoiseFilter"
                        var iconName = "filter3"

                    }else if keyFilter == "#04" {
                         ApplyMonoFilter(fileURL!)
                        var filterName = "MonoFilter"
                        var iconName = "filter4"

                    }else if keyFilter == "#05" {
                         ApplyPolyFilter(fileURL!)
                        var filterName = "PolyFilter"
                        var iconName = "filter5"

                    }else if keyFilter == "#06" {
                         ApplyFadeFilter(fileURL!)
                        var filterName = "FadeFilter"
                        var iconName = "filter6"

                    }else if keyFilter == "#07" {
                         ApplyNormalFilter(fileURL!)
                        var filterName = "NormalFilter"
                        var iconName = "filter7"

                    }else if keyFilter == "#08" {
                         ApplySmallFilter(fileURL!)
                        var filterName = "SmallFilter"
                        var iconName = "filter8"

                    }
                    
                    removeFile(fileList[i])
                    updateProgress(i + 1, count: count)
                }
            }
            
            var numberOfPhoto = String(count)
            
            userSetting.setObject([save.variable.key, filterName, iconName, numberOfPhoto], forKey: save.variable.key)
            self.userSetting.setObject(["", "", "", 10, false], forKey: save.variable.key)
           processView.hidden = true
            GaleryView.hidden = false

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
    
    func updateProgress(last: Int, count:Int) {
        progressBar?.progress += (Float(last) * 100) / Float(count)
        let progressValue = self.progressBar?.progress
        let calCount = progressValue!
        let intCount = Int((Float(last) * 100) / Float(count))
        progressLabel?.text = "\(intCount) %"
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
    
    func ApplyCCtrlFilter(fileURL:NSURL) {
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
        self.moveFile(newImage!)
       
    }
    
    func ApplySepiaFilter(fileURL:NSURL) {
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
        self.moveFile(newImage!)
    }
    
    func ApplyReduceNoiseFilter(fileURL:NSURL) {
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
        self.moveFile(newImage2!)
    }
    
   func ApplyMonoFilter(fileURL:NSURL) {
        //CIMaximumComponent
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIMaximumComponent")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let newImage = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent()))
    self.moveFile(newImage!)
    }
    
    func ApplyPolyFilter(fileURL:NSURL) {
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
        self.moveFile(newImage!)
        
    }
    
    func ApplyFadeFilter(fileURL:NSURL) {
        //CIPhotoEffectFade
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIPhotoEffectFade")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let newImage = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent()))
        self.moveFile(newImage!)
    }
    
    func ApplyNormalFilter(fileURL:NSURL) {
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
        self.moveFile(newImage!)
        
    }
    
    func ApplySmallFilter(fileURL:NSURL) {
        //CIPhotoEffectFade
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIPhotoEffectFade")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let newImage = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent()))
        self.moveFile(newImage!)
    }
    
    
    func moveFile(image: UIImage) {
        initial().createSubDirectory("CompletedData", subDir: keySlot)
        
        var format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        var currentFileName: String = "img-\(format.stringFromDate(NSDate())).jpg"
        println(currentFileName)

        initial().createSubAndFileDirectory("CompletedData", subDir: keySlot, file: currentFileName, image: image)
    }

}
