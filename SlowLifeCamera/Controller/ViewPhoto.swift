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

class ViewPhoto: UIViewController {
    var filterImage = [String]()
    var index: Int = 0
    var keySlot = ""
    var imageResource = UIImage()
    
    //@Export photo
    @IBAction func save(sender : AnyObject) {
    UIImageWriteToSavedPhotosAlbum(self.imageResource, nil, nil, nil);
        
        let alertController = UIAlertController(title: "", message:
            "Already save photo to gallery", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
                // 4
                self.presentViewController(controller, animated:true, completion:nil)
            }
            else {
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
}