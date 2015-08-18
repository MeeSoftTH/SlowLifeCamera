//
//  ViewPhoto.swift
//  Photos Gallery App
//
//  Created by Tony on 7/7/14.
//  Copyright (c) 2014 Abbouds Corner. All rights reserved.
//
//  Updated for Xcode 6.0.1 GM

import UIKit
import Social
import Photos

protocol updateCoinsViewPhoto {
    func updateCoinsViewPhoto2(myCoins: Int)
}

class ViewPhoto: UIViewController {
    var filterImage = [String]()
    var index: Int = 0
    var keySlot = ""
    var imageResource = UIImage()
    
    var delegate: updateCoinsViewPhoto = DataSetting.variable.controller
    
    @IBAction func save(sender : AnyObject) {
        PHPhotoLibrary.requestAuthorization
            {(PHAuthorizationStatus status) -> Void in
                switch (status)
                
                {
                case .Authorized:
                    // Permission Granted
                    println("Write your code here")
                    UIImageWriteToSavedPhotosAlbum(self.imageResource, nil, nil, nil)
                    
                    let alertControl = UIAlertController(title: "Saved!", message: "The photo has been saved.", preferredStyle: .Alert)
                    alertControl.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alertControl, animated: true, completion: nil)
                    
                case .Denied:
                    println("User denied")
                default:
                    println("Restricted")
                }
        }
    }
    
    @IBAction func shareTo(sender: UIBarButtonItem) {
        
        var chooseDialog = UIAlertController(title: "Post to social network", message: "Choose your social network?",preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        chooseDialog.addAction(UIAlertAction(title: "Facebook", style: .Default, handler: { (action: UIAlertAction!) in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                // 2
                var controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                // 3
                controller.setInitialText("Posting by SLOW LIFE CAMERA APP")
                controller.addImage(self.imgView.image)
                
                controller.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                    switch result {
                    case SLComposeViewControllerResult.Cancelled:
                        NSLog("result: cancelled")
                    case SLComposeViewControllerResult.Done:
                        // TODO: ADD SOME CODE FOR SUCCESS
                        
                        self.delay(1.0) {
                            let alertController = UIAlertController(title: "Congratulations", message:
                                "Your got 100 coins from share photo action", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
                                self.gifeCoins()
                                
                            }))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                        NSLog("result: done")
                    }
                }
                
                self.presentViewController(controller, animated: true, completion: nil)
                
            }else {
                // 3
                let alertController = UIAlertController(title: "Alert", message:
                    "Sign to Facebook first!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }))
        
        chooseDialog.addAction(UIAlertAction(title: "Twitter", style: .Default, handler: { (action: UIAlertAction!) in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                var tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                tweetSheet.setInitialText("Posting by SLOW LIFE CAMERA APP")
                tweetSheet.addImage(self.imgView.image)
                
                tweetSheet.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                    switch result {
                    case SLComposeViewControllerResult.Cancelled:
                        NSLog("result: cancelled")
                    case SLComposeViewControllerResult.Done:
                        // TODO: ADD SOME CODE FOR SUCCESS
                        
                        self.delay(1.0) {
                            let alertController = UIAlertController(title: "Congratulations", message:
                                "Your got 100 coins from share photo action", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
                                self.gifeCoins()
                                
                            }))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                        NSLog("result: done")
                    }
                }
                
                self.presentViewController(tweetSheet, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Alert", message:
                    "Sign to Twitter first!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }))
        
        chooseDialog.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(chooseDialog, animated: true, completion: nil)
    }
    
    @IBAction func close(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet var imgView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.displayPhoto()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func displayPhoto(){
        
        println("ShotPath = \(self.index)")
        println("Array = \(self.filterImage)")
        
        let shotPath: AnyObject = self.filterImage[self.index]
        
        var theError = NSErrorPointer()
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if dirs != nil {
            let dir = dirs![0]
            let fullPath = "\(dir)/CompletedData/\(self.keySlot)/\(shotPath)"
            
            
            let image = UIImage(contentsOfFile: fullPath)
            
            if image != nil {
                imgView.image = image
                self.imageResource = image!
            }
            
        }
    }
    
    func gifeCoins() {
        
        var intCoins: Int = userSetting.integerForKey("myCoins")
        
        intCoins = intCoins + 100
        
        self.delegate.updateCoinsViewPhoto2(intCoins)
    }
    
    
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}
