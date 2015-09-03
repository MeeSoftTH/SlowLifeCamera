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

let userSetting: NSUserDefaults! = NSUserDefaults.standardUserDefaults()

class FilterViewController: UIViewController {
    
    @IBOutlet var status: UILabel!
    @IBOutlet var act: UIActivityIndicatorView!
    @IBOutlet var actionButton: UIButton!
    
    var delegate: removeFilm? = nil
    var datas:String = DataSetting.variable.key
    var subDir:String = ""
    var subDir2:String = ""
    var keyFilter: String = ""
    var isCancel: Bool = false
    var isCreated: Bool = false
    var textLength: Int = 0
    var isShowText: Bool = false
    var isShowFrame: Bool = false
    
    let showCopy = userSetting.boolForKey("showCopyRight")
    let showTime = userSetting.boolForKey("ShowTime")
    let showLocation = userSetting.boolForKey("showLocation")
    let showFrame = userSetting.boolForKey("showFrame")
    
    let context = CIContext(options: nil)
    
    override func viewDidLoad() {
        self.isShowText = showCopy == true || showTime == true || showLocation == true ? true : false
        self.isShowFrame = showFrame == true ? true : false
        
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let datas: AnyObject? = userSetting?.objectForKey(DataSetting.variable.key)
        self.subDir = datas!.objectAtIndex(0) as! String
        self.keyFilter = datas!.objectAtIndex(1) as! String
        let count = datas!.objectAtIndex(3) as! Int
        let textLength = datas!.objectAtIndex(4) as! Int
        
        
        
        println("Data filter: subDir = \(subDir), keyFilter = \(keyFilter)")
        
        delay(3.0){
            if !self.isCancel {
                self.processFilter()
            }else{
                println("Process is cancel")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        DataSetting.variable.isProcess = true
        
        self.actionButton.enabled = false
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        var fileList = listFilesFromDocumentsFolder()
        let count = fileList.count
        println(String(format: "Start Process %@", keyFilter))
        if count > 0 {
            var filterName = DataSetting.variable.filter1
            var iconName = DataSetting.variable.iconFilter1
            
            let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = dir[0]
            
            autoreleasepool {
                for i in 0..<count {
                    status.text = String(format: "Developing %d of %d", i + 1, count)
                    NSRunLoop.mainRunLoop().runUntilDate(NSDate().dateByAddingTimeInterval(0.5))
                    var getImagePath = documentsDirectory.stringByAppendingPathComponent("RawData/\(self.subDir)/\(fileList[i])")
                    println("Path:" + getImagePath)
                    //releaseMemory(getImagePath)
                    
                    var fileURL = NSURL(fileURLWithPath: getImagePath)
                    //releaseMemory(getImagePath)
                    var gotImg = UIImage(contentsOfFile: getImagePath)
                    println(gotImg?.imageOrientation.rawValue)
                    if keyFilter == "#01" {
                        ApplyFilterNO7(fileURL!, rename: fileList[i], orientation: gotImg!.imageOrientation)
                        filterName = DataSetting.variable.filter1
                        iconName = DataSetting.variable.iconFilter1
                    }else if keyFilter == "#02" {
                        ApplySepiaFilter(fileURL!, rename: fileList[i], orientation: gotImg!.imageOrientation)
                        filterName = DataSetting.variable.filter2
                        iconName = DataSetting.variable.iconFilter2
                    }else if keyFilter == "#03" {
                        ApplyMonoFilter(fileURL!, rename: fileList[i], orientation: gotImg!.imageOrientation)
                        filterName = DataSetting.variable.filter3
                        iconName = DataSetting.variable.iconFilter3
                    }else if keyFilter == "#04" {
                        ApplyFilterNO10(fileURL!, rename: fileList[i], orientation: gotImg!.imageOrientation)
                        filterName = DataSetting.variable.filter4
                        iconName = DataSetting.variable.iconFilter4
                    }else if keyFilter == "#05" {
                        ApplyPolyFilter(fileURL!, rename: fileList[i], orientation: gotImg!.imageOrientation)
                        filterName = DataSetting.variable.filter5
                        iconName = DataSetting.variable.iconFilter5
                    }else if keyFilter == "#06" {
                        ApplyFilterNO9(fileURL!, rename: fileList[i], orientation: gotImg!.imageOrientation)
                        filterName = DataSetting.variable.filter6
                        iconName = DataSetting.variable.iconFilter6
                    }else if keyFilter == "#07" {
                        ApplyFilterNO14(fileURL!, rename: fileList[i], orientation: gotImg!.imageOrientation)
                        filterName = DataSetting.variable.filter7
                        iconName = DataSetting.variable.iconFilter7
                    }else if keyFilter == "#08" {
                        ApplyFilterNO13(fileURL!, rename: fileList[i], orientation: gotImg!.imageOrientation)
                        filterName = DataSetting.variable.filter8
                        iconName = DataSetting.variable.iconFilter8
                        
                    }
                    
                    removeFile(fileList[i])
                }
            }
            
            println("Set to key = \(self.subDir2)")
            
            let removeDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            
            let removeIndexDir: AnyObject = removeDir[0]
            
            var removePath = removeIndexDir.stringByAppendingPathComponent("RawData/\(self.subDir)")
            //releaseMemory(removePath)
            
            let fileDir = NSFileManager.defaultManager()
            var removeErrorrror: NSError?
            
            if fileDir.removeItemAtPath(removePath, error: &removeErrorrror) {
                println("\(removePath) = Remove Dir successful")
            } else {
                println("Remove failed: \(removeErrorrror!.localizedDescription)")
            }
            
            var numberOfPhoto = String(DataSetting.variable.filterSuccess)
            
            userSetting.setObject([self.subDir2, filterName, iconName, numberOfPhoto], forKey: self.subDir2)
            
            userSetting.setObject(["", "", "", 0, false], forKey: DataSetting.variable.key)
            DataSetting.variable.key = ""
            
            DataSetting.variable.filterSuccess = 0
            DataSetting.variable.key = ""
            
            self.delegate?.removeAfterSuccess(true)
            
            DataSetting.variable.rowSlected = false
            DataSetting.variable.isProcess = false
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }else {
            println("No photo")
            
            self.dismissViewControllerAnimated(true, completion: nil)
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
        //releaseMemory(imagePath)
        //releaseMemory(imagePath)
        
        let filemgr = NSFileManager.defaultManager()
        var error: NSError?
        
        if filemgr.removeItemAtPath(imagePath, error: &error) {
            println("\(imagePath) = Remove successful")
        } else {
            println("Remove failed: \(error!.localizedDescription)")
        }
        return
    }
    
    func ApplyCCtrlFilter(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        let filter = CIFilter(name: "CIColorControls")
        let ciImage = CIImage(contentsOfURL: fileURL)
        
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.92, forKey: kCIInputSaturationKey)
        filter.setValue(0.98, forKey: kCIInputContrastKey)
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
        
    }
    
    func ApplySepiaFilter(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        let filter = CIFilter(name: "CISepiaTone")
        let ciImage = CIImage(contentsOfURL: fileURL)
        
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.87, forKey: kCIInputIntensityKey)
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
        
    }
    
    func ApplyReduceNoiseFilter(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
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
        
        let imageCG: CGImage = context.createCGImage(filter2.outputImage, fromRect: filter2.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyMonoFilter(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        //CIMaximumComponent
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIMaximumComponent")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyPolyFilter(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
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
        
        let imageCG: CGImage = context.createCGImage(filter2.outputImage, fromRect: filter2.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
        
    }
    
    func ApplyFadeFilter(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        //CIPhotoEffectFade
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIPhotoEffectFade")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyFilterNO7(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIHighlightShadowAdjust")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        //filter.setValue(1.8, forKey: "inputHighlightAmount")
        filter.setValue(0.3, forKey: "inputShadowAmount")
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyFilterNO8(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIVignetteEffect")
        //filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let floatArr: [CGFloat] = [0,0]
        var vector = CIVector(values: floatArr, count: floatArr.count)
        filter.setValue(vector, forKey: "inputCenter")
        filter.setValue(0.24, forKey: "inputIntensity")
        filter.setValue(0, forKey: "inputRadius")
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyFilterNO9(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIHighlightShadowAdjust")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.4, forKey: "inputShadowAmount")
        
        let filter2 = CIFilter(name: "CIColorMonochrome")
        filter2.setValue(filter.outputImage, forKey: kCIInputImageKey)
        let color = CIColor(color: UIColor(red: 0.85, green: 0.16, blue: 0.02, alpha: 1.0));
        filter2.setValue(color, forKey: "inputColor")
        filter2.setValue(1.0, forKey: "inputIntensity")
        
        let imageCG: CGImage = context.createCGImage(filter2.outputImage, fromRect: filter2.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)

        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyFilterNO10(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIColorPosterize")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(27, forKey: "inputLevels")
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyFilterNO11(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIUnsharpMask")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(2.9, forKey: "inputRadius")
        filter.setValue(0.72, forKey: "inputIntensity")
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyFilterNO12(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIGloom")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(8.1, forKey: "inputRadius")
        filter.setValue(0.5, forKey: "inputIntensity")
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyFilterNO13(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
        let ciImage = CIImage(contentsOfURL: fileURL)
        let filter = CIFilter(name: "CIConvolution3X3")
        //filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let floatArr: [CGFloat] = [0, -2, 0, -2, 9, 0, -2, 0, -2]
        var vector = CIVector(values: floatArr, count: floatArr.count)
        filter.setValue(vector, forKey: "inputWeights")
        filter.setValue(0.0, forKey: "inputBias")
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyFilterNO14(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
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
        
        let imageCG: CGImage = context.createCGImage(ciImage, fromRect: rect)
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        
        self.moveFile(finalImage, newName: rename)
    }
    
    func ApplyFilterNO15(fileURL:NSURL, rename: String, orientation: UIImageOrientation) {
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
        
        let imageCG: CGImage = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
        
        let finalImage = ProcessFilterImage(imageCG, orientation: orientation, useFrame: isShowFrame, useText: isShowText, nameText: rename)
        self.moveFile(finalImage, newName: rename)
    }
    
    func ProcessFilterImage(cgImage : CGImage, orientation: UIImageOrientation, useFrame: Bool, useText: Bool, nameText: String) -> UIImage{
        
        // First: Create UIImage from filtered image plus rotate it to real orientation.
        var uImage = UIImage(CGImage: cgImage, scale: CGFloat(1.0), orientation: orientation)
        
        // Last: Check nees to add Frame or Text on image or not.
        if(useFrame || useText){
            return addTextAndFrame(uImage!, useFrame: useFrame, nameText: nameText);
        }
        else {
            return uImage!
        }
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
            
        }else {
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
            
        }else {
            inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        }
        
        // Creating a point within the space that is as bit as the image.
        var rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        if showCopy == true {
            getCopyText().drawInRect(rect, withAttributes: textFontAttributes)
        }
        
        var timeParagraphStyle = NSMutableParagraphStyle()
        timeParagraphStyle.alignment = NSTextAlignment.Right
        
        let timeTextFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: timeParagraphStyle
        ]
        
        let gab2 = (frameSize * 2);
        
        let atPoint2 = CGPointMake(frameSize - gab2, imgHeight - fontSize - gab)
        
        var timeRect: CGRect = CGRectMake(atPoint2.x, atPoint2.y, inImage.size.width, inImage.size.height)
        
        if showTime == true || showLocation == true {
            getTimeAndLocationText(nameText).drawInRect(timeRect, withAttributes: timeTextFontAttributes)
        }
        
        // Create a new image out of the images we have created
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
    }
    
    func getCopyText()-> String {
        
        let text = "©SlowLife Camera"
        
        println("Text is = \(text)")
        
        return text
    }
    
    func getTimeAndLocationText(textString: String)-> String {
        
        var timeText: String = ""
        var locationText: String = ""
        
        var fullNameArr = split(textString) {$0 == ","}
        
        if showTime == true {
            let getTime = split(fullNameArr[0]) {$0 == "_"}
            
            let tempDate = getTime[0]
            let tempTime = getTime[1]
            
            // Cut Date
            let yy = tempDate.substringWithRange(Range<String.Index>(start: advance(tempDate.startIndex, 0), end: advance(tempDate.endIndex, -4)))
            
            let mm = tempDate.substringWithRange(Range<String.Index>(start: advance(tempDate.startIndex, 4), end: advance(tempDate.endIndex, -2)))
            
            let dd = tempDate.substringWithRange(Range<String.Index>(start: advance(tempDate.startIndex, 6), end: advance(tempDate.endIndex, 0)))
            
            let date = "\(yy)-\(mm)-\(dd)"
            
            println("date is = \(date)")
            
            // Cut time
            
            println("temp time = \(tempTime)")
            let hr = tempTime.substringWithRange(Range<String.Index>(start: advance(tempTime.startIndex, 0), end: advance(tempTime.endIndex, -8)))
            
            let min = tempTime.substringWithRange(Range<String.Index>(start: advance(tempTime.startIndex, 2), end: advance(tempTime.endIndex, -6)))
            
            let time = "\(hr):\(min)"
            
            println("time is \(time)")
            
            timeText = "\(date) \(time)"
            
            println("timeText is = \(timeText)")
        }
        
        var text = ""
        
        if showTime == true && showLocation == false {
            text = "\(timeText)"
        }else if showTime == false && showLocation == true {
            text = "\(locationText)"
        }else if showTime == true && showLocation == true {
            text = "\(timeText), \(locationText)"
        }
        
        println("Text is = \(text)")
        
        return text
        
    }
    
    func moveFile(image: UIImage, newName: String) {
        
        if isCreated == false {
            var currentTime = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "ddMMyy-HHmm" // superset of OP's format
            let str = dateFormatter.stringFromDate(currentTime)
            
            let newKey =  GlobalFunction().createSubDirectory("CompletedData", subDir: str)
            isCreated = true
            
            self.subDir2 = newKey
            
            println("New path = \(newKey)")
        }
        
        var fullNameArr = split(newName) {$0 == "."}
        //newName.substringWithRange(Range(0, 19))
        
        var currentFileName: String = "slowlife-\(fullNameArr[0]).jpg"
        println("NewName = \(currentFileName)")
        
       
        GlobalFunction().createSubAndFileDirectory("CompletedData", subDir: self.subDir2, file: currentFileName, image: image)
        DataSetting.variable.filterSuccess += 1
    }
    
}
