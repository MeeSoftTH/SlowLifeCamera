//
//  FilterViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/21/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

protocol removeFilm {
    func removeAfterSuccess(isTrue: Bool, coinsUpdate: String)
}

let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")

class FilterViewController: UIViewController {
    
    @IBOutlet var status: UILabel!
    @IBOutlet var act: UIActivityIndicatorView!
    @IBOutlet var imageSet: UIImageView!
    @IBOutlet var actionButton: UIButton!
    
    var delegate: removeFilm? = nil
    var datas:String = save.variable.key
    var subDir:String = ""
    var subDir2:String = ""
    var keyFilter: String = ""
    var isCancel: Bool = false
    
    
    let showCopy = userSetting.boolForKey("showCopyRight")
    let showTime = userSetting.boolForKey("ShowTime")
    let showLocation = userSetting.boolForKey("showLocation")
    
    @IBOutlet var galleryButton: UIButton!
    
    let context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        releaseMemory()
        var currentTime = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ddMMyy-H:mm" // superset of OP's format
        let str = dateFormatter.stringFromDate(currentTime)
        
        self.subDir2 = str
        let datas: AnyObject? = userSetting?.objectForKey(save.variable.key)
        self.subDir = datas!.objectAtIndex(0) as! String
        self.keyFilter = datas!.objectAtIndex(1) as! String
        
        delay(5.0){
            
            if !self.isCancel {
                self.processFilter()
            }else{
            println("Process is cancel")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.isCancel = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func processFilter() {
        self.actionButton.enabled = false
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        var fileList = listFilesFromDocumentsFolder()
        
        let count = fileList.count
        
        println("Number of photos = \(count)")
        if count > 0 {
            var filterName = "No.14"
            var iconName = "filter1"
            
            let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            
            let documentsDirectory: AnyObject = dir[0]
            
            for var i:Int = 0; i < count; i++
            {
                releaseMemory()
                if fileManager.fileExistsAtPath(fileList[i]) != true
                {
                    println("File is \(fileList[i])")
                    
                    var getImagePath = documentsDirectory.stringByAppendingPathComponent("RawData/\(self.subDir)/\(fileList[i])")
                    
                    
                    
                    var fileURL = NSURL(fileURLWithPath: getImagePath)
                    
                    if keyFilter == "#01" {
                        ApplyFilterNO14(fileURL!, rename: fileList[i])
                        filterName = "No.14"
                        iconName = "filter1"
                        
                    }else if keyFilter == "#02" {
                        ApplySepiaFilter(fileURL!, rename: fileList[i])
                        filterName = "Sepia"
                        iconName = "filter2"
                        
                    }else if keyFilter == "#03" {
                        ApplyMonoFilter(fileURL!, rename: fileList[i])
                        filterName = "Sepia"
                        iconName = "filter3"
                        
                    }else if keyFilter == "#04" {
                        ApplyFilterNO10(fileURL!, rename: fileList[i])
                        filterName = "No.10"
                        iconName = "filter4"
                        
                        
                    }else if keyFilter == "#05" {
                        ApplyPolyFilter(fileURL!, rename: fileList[i])
                        filterName = "Poly"
                        iconName = "filter5"
                        
                    }else if keyFilter == "#06" {
                        ApplyFilterNO9(fileURL!, rename: fileList[i])
                        filterName = "No.9"
                        iconName = "filter6"
                        
                    }else if keyFilter == "#07" {
                        ApplyFilterNO7(fileURL!, rename: fileList[i])
                        filterName = "No.7"
                        iconName = "filter7"
                        
                    }else if keyFilter == "#08" {
                        ApplyFilterNO13(fileURL!, rename: fileList[i])
                        filterName = "No.13"
                        iconName = "filter8"
                        
                    }
                    
                    removeFile(fileList[i])
                    releaseMemory()
                }
            }
            
            println("Set to key = \(self.subDir2)")
            println("New datas \(userSetting.objectForKey(self.subDir2))")
            
            let removeDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            
            let removeIndexDir: AnyObject = removeDir[0]
            
            var removePath = removeIndexDir.stringByAppendingPathComponent("RawData/\(self.subDir)")
            
            let fileDir = NSFileManager.defaultManager()
            var removeErrorrror: NSError?
            
            if fileDir.removeItemAtPath(removePath, error: &removeErrorrror) {
                println("\(removePath) = Remove Dir successful")
            } else {
                println("Remove failed: \(removeErrorrror!.localizedDescription)")
            }
            
            var intCoins: Int = userSetting.integerForKey("myCoins")
            
            intCoins = intCoins + save.variable.filterSuccess
            
            userSetting.setInteger(intCoins, forKey: "myCoins")
            
            var numberOfPhoto = String(save.variable.filterSuccess)
            
            userSetting.setObject([self.subDir2, filterName, iconName, numberOfPhoto], forKey: self.subDir2)
            
            userSetting.setObject(["", "", "", 25, false], forKey: save.variable.key)
            save.variable.key = ""
            
            save.variable.filterSuccess = 0
            save.variable.key = ""
            
            
            self.delegate?.removeAfterSuccess(true, coinsUpdate: String(intCoins))
            
            save.variable.rowSlected = false
            
            self.actionButton.enabled = true
            self.status.text = "Successful"
            self.act.hidden = true
            self.actionButton.setTitle("Close", forState: UIControlState.Normal)
            self.imageSet.image = UIImage(named: "success")
            
            let alertController = UIAlertController(title: "Successful", message:
                "Convert photos with filter successfuly!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else {
            println("No photo")
        }
    }
    
    func listFilesFromDocumentsFolder() -> [String]
    {
        var theError = NSErrorPointer()
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if dirs != nil {
            println("This slot = \(self.subDir)")
            let dir = dirs![0]
            let fileList = NSFileManager.defaultManager().contentsOfDirectoryAtPath("\(dir)/RawData/\(self.subDir)", error: theError)
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
        
        var imagePath = documentsDirectory.stringByAppendingPathComponent("RawData/\(self.subDir)/\(path)")
        
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
        
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        let newImage = textImg
        self.moveFile(newImage, newName: rename)
        
    }
    
    func ApplySepiaFilter(fileURL:NSURL, rename: String) {
        let filter = CIFilter(name: "CISepiaTone")
        let ciImage = CIImage(contentsOfURL: fileURL)
        
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.87, forKey: kCIInputIntensityKey)
        
        //let context = CIContext(options:nil)
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        let newImage = textImg
        
        self.moveFile(newImage, newName: rename)
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
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        let newImage = textImg
        
        self.moveFile(newImage, newName: rename)
    }
    
    func ApplyMonoFilter(fileURL:NSURL, rename: String) {
        //CIMaximumComponent
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIMaximumComponent")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        
        let newImage = textImg
        self.moveFile(newImage, newName: rename)
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
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        
        let newImage = textImg
        self.moveFile(newImage, newName: rename)
        
    }
    
    func ApplyFadeFilter(fileURL:NSURL, rename: String) {
        //CIPhotoEffectFade
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIPhotoEffectFade")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        
        let newImage = textImg
        self.moveFile(newImage, newName: rename)
    }
    
    func ApplyFilterNO7(fileURL:NSURL, rename: String) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIHighlightShadowAdjust")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        //filter.setValue(1.8, forKey: "inputHighlightAmount")
        filter.setValue(0.3, forKey: "inputShadowAmount")
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        
        let newImage = textImg
        self.moveFile(newImage, newName: rename)
    }
    
    func ApplyFilterNO8(fileURL:NSURL, rename: String) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIVignetteEffect")
        //filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let floatArr: [CGFloat] = [0,0]
        var vector = CIVector(values: floatArr, count: floatArr.count)
        filter.setValue(vector, forKey: "inputCenter")
        filter.setValue(0.24, forKey: "inputIntensity")
        filter.setValue(0, forKey: "inputRadius")
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        
        let newImage = textImg
        self.moveFile(newImage, newName: rename)
    }
    
    func ApplyFilterNO9(fileURL:NSURL, rename: String) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIHighlightShadowAdjust")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.4, forKey: "inputShadowAmount")
        
        let filter2 = CIFilter(name: "CIColorMonochrome")
        filter2.setValue(filter.outputImage, forKey: kCIInputImageKey)
        let color = CIColor(color: UIColor(red: 0.85, green: 0.16, blue: 0.02, alpha: 1.0));
        filter2.setValue(color, forKey: "inputColor")
        filter2.setValue(1.0, forKey: "inputIntensity")
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        
        let newImage = textImg
        self.moveFile(newImage, newName: rename)
    }
    
    func ApplyFilterNO10(fileURL:NSURL, rename: String) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIColorPosterize")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(27, forKey: "inputLevels")
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()), scale: CGFloat(1.0), orientation: UIImageOrientation.Right)
        
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        let newImage = textImg
        self.moveFile(newImage, newName: rename)
    }
    
    func ApplyFilterNO11(fileURL:NSURL, rename: String) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIUnsharpMask")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(2.9, forKey: "inputRadius")
        filter.setValue(0.72, forKey: "inputIntensity")
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        let newImage = textImg
        
        self.moveFile(newImage, newName: rename)
    }
    
    func ApplyFilterNO12(fileURL:NSURL, rename: String) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIGloom")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(8.1, forKey: "inputRadius")
        filter.setValue(0.5, forKey: "inputIntensity")
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        let newImage = textImg
        
        self.moveFile(newImage, newName: rename)
    }
    
    func ApplyFilterNO13(fileURL:NSURL, rename: String) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIConvolution3X3")
        //filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let floatArr: [CGFloat] = [0, -2, 0, -2, 9, 0, -2, 0, -2]
        var vector = CIVector(values: floatArr, count: floatArr.count)
        filter.setValue(vector, forKey: "inputWeights")
        filter.setValue(0.0, forKey: "inputBias")
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        let newImage = textImg
        
        self.moveFile(newImage, newName: rename)
    }
    
    func ApplyFilterNO14(fileURL:NSURL, rename: String) {
        var ciImage = CIImage(contentsOfURL: fileURL)
        let imgWidth = ciImage.extent().width
        let imgHeight = ciImage.extent().height
        let rect = ciImage.extent()
        let color0 = CIColor(color: UIColor(red: 0.87, green: 0.76, blue: 0.56, alpha: 0.4));
        let numberOfDots = randomNumberBetween(0, max: 7)
        //var maskImage : CIImage = nil
        for i in 0...numberOfDots {
            let randW = randomNumberBetween(0, max: Int(imgWidth))
            let randH = randomNumberBetween(0, max: Int(imgHeight))
            let randR = randomNumberBetween(0, max: 30)
            let filter = CIFilter(name: "CIStarShineGenerator")
            filter.setDefaults()
            let floatArr: [CGFloat] = [CGFloat(randW), CGFloat(randH)]
            var vector = CIVector(values: floatArr, count: floatArr.count)
            filter.setValue(vector, forKey: "inputCenter")
            
            filter.setValue(color0, forKey: "inputColor")
            filter.setValue(0.2, forKey: "inputCrossScale")
            filter.setValue(-10, forKey: "inputCrossOpacity")
            filter.setValue(randR, forKey: "inputRadius")
            let filter2 = CIFilter(name: "CISourceOverCompositing")
            filter2.setValue(filter.outputImage, forKey: kCIInputImageKey)
            filter2.setValue(ciImage, forKey: "inputBackgroundImage")
            ciImage = filter2.outputImage
        }
        var image = UIImage(CGImage: context.createCGImage(ciImage, fromRect: rect))
        let textImg = addTextAndFrame(image!, useFrame: true, nameText: rename);
        
        let newImage = textImg//UIImage(CGImage: context.createCGImage(ciImage, fromRect: rect))
        
        self.moveFile(newImage, newName: rename)
    }
    
    func ApplyFilterNO15(fileURL:NSURL, rename: String) {
        let filter = CIFilter(name: "CIStripesGenerator")
        let floatArr: [CGFloat] = [100,100]
        var vector = CIVector(values: floatArr, count: floatArr.count)
        filter.setValue(vector, forKey: "inputCenter")
        
        let color0 = CIColor(color: UIColor(red: 0.87, green: 0.48, blue: 0.12, alpha: 0.4));
        filter.setValue(color0, forKey: "inputColor0")
        let color1 = CIColor(color: UIColor(red: 0, green: 10, blue: 0, alpha: 0.01));
        filter.setValue(color1, forKey: "inputColor1")
        filter.setValue(0.07, forKey: "inputWidth")
        filter.setValue(0.5, forKey: "inputSharpness")
        
        let ciImage = CIImage(contentsOfURL: fileURL)
        let imgWidth = ciImage.extent().width
        let imgHeight = ciImage.extent().height
        let filter2 = CIFilter(name: "CISourceOverCompositing")
        filter2.setValue(filter.outputImage, forKey: kCIInputImageKey)
        filter2.setValue(ciImage, forKey: "inputBackgroundImage")
        
        
        println(imgWidth)
        println(imgHeight)
        
        var image = UIImage(CGImage: context.createCGImage(filter.outputImage, fromRect: ciImage.extent()))
        
        let textImg = addTextAndFrame(image!, useFrame: false, nameText: rename);
        
        let newImage = textImg// UIImage(CGImage: context.createCGImage(filter3.outputImage, fromRect: ciImage.extent()))
        
        self.moveFile(newImage, newName: rename)
    }
    
    
    func getText(nameText: String)-> String {
        
        var cutLocation = nameText
        var cutTime = nameText
        
        var copyText: String = ""
        var timeText: String = ""
        var locationText: String = ""
        
        
        if showTime == true {
            let endIndex = advance(cutTime.startIndex, 19)
            let needle = cutTime.substringToIndex(endIndex)
            println("Time is = \(needle)")
            timeText = " : \(needle)"
        }
        
        if showLocation == true{
            if count(nameText) > 19 {
                cutLocation.removeRange(cutLocation.startIndex..<advance(cutLocation.startIndex, 20))
                let newStr = cutLocation[advance(cutLocation.startIndex, 0)...advance(cutLocation.endIndex, -4)]
                println("Location is = \(newStr)")
                locationText = " : \(newStr)"
            }
        }
        
        if showCopy == true {
            copyText = "Film By SlowLife Camera"
        }
        
        let text = "\(copyText) \(timeText) \(locationText)"
        
        println("Text is = \(text)")
        
        return text
    }
    
    func randomNumberBetween(min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
    
    func addTextAndFrame(inImage: UIImage, useFrame: Bool, nameText: String)->UIImage{
        
        var fontSize: CGFloat = 10
        var frameSize: CGFloat = 10
        let imgWidth = inImage.size.width
        let imgHeight = inImage.size.height
        
        if(imgWidth > imgHeight){
            fontSize = imgHeight * 3 / 100
            frameSize = imgHeight * 5 / 100
        }
        else {
            fontSize = imgWidth * 3 / 100
            frameSize = imgWidth * 5 / 100
        }
        let gab = ((frameSize - fontSize)/2);
        println(fontSize)
        println(frameSize)
        let atPoint = CGPointMake(frameSize + gab, imgHeight - fontSize - gab)
        
        // Setup the font specific variables
        var textColor: UIColor = useFrame ? UIColor.blackColor() : UIColor.orangeColor()
        var textFont: UIFont = UIFont(name: "Helvetica Bold", size: fontSize)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        if useFrame {
            inImage.drawInRect(CGRectMake(frameSize, frameSize, inImage.size.width - (frameSize*2), inImage.size.height - (frameSize*2)))
        }
        else {
            inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        }
        
        // Creating a point within the space that is as bit as the image.
        var rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        getText(nameText).drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
    }
    
    func moveFile(image: UIImage, newName: String) {
        initial().createSubDirectory("CompletedData", subDir: self.subDir2)
        
        let endIndex = advance(newName.startIndex, 19)
        let needle = newName.substringToIndex(endIndex)
        println("Time is = \(needle)")
        
        //newName.substringWithRange(Range(0, 19))
        
        var currentFileName: String = "slowlife-\(needle).jpg"
        println("NewName = \(currentFileName)")
        
        let UIimg = UIImage(CGImage: image.CGImage, scale: 1.0, orientation: UIImageOrientation.Right)
        
        initial().createSubAndFileDirectory("CompletedData", subDir: self.subDir2, file: currentFileName, image: UIimg!)
        
        save.variable.filterSuccess += 1
    }
    
    func releaseMemory() {
        var counter = 0
        for i in 0..<10 {
            autoreleasepool {
                if i == 5 {
                    return
                }
                counter++
            }
        }
    }
}
