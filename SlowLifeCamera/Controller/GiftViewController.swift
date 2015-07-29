//
//  GiftViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/9/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

protocol updateCoins {
    func updateCoinsGift(myCoins: String)
}

class GiftViewController: UIViewController, UnityAdsDelegate, disableUI {
    
    @IBOutlet weak var slowGift: UIButton!
    @IBOutlet weak var redGift: UIView!
    @IBOutlet weak var blueGift: UIView!
    @IBOutlet weak var greenGift: UIView!
    
    @IBOutlet var actInd: UIActivityIndicatorView!
    @IBOutlet var giftStatueNot: UILabel!
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    var uiClick: UIButton!
    var timer: NSTimer!
    var stateAds = NSDate()
    var stateGift = NSDate()
    
    var delegate: updateCoins? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Preload")
        UnityAds.sharedInstance().delegate = self
        UnityAds.sharedInstance().startWithGameId("51551")
        
        let stateLast: AnyObject? = userSetting.objectForKey("lasttime")
        if stateLast != nil {
            let date = NSDate()
            
            let date1 : NSDate = stateLast as! NSDate
            let date2 : NSDate = date
            
            let compareResult = date2.compare(date1)
            
            let interval = date2.timeIntervalSinceDate(date1)
            
            
            if interval > 18000 {
                slowGift.enabled = true
            }
            println("time check = \(interval)")
        }else {
            let date = NSDate()
            slowGift.enabled = true
            println("button enable = \(slowGift.enabled)")
        }
        
        var stateTimeTemp = NSDate()
        
        let stateTime: AnyObject? = userSetting.objectForKey("adsTime")
        if stateTime != nil {
            
            let date = NSDate()
            
            var date1 : NSDate = stateTime as! NSDate
            var date2 : NSDate = date
            
            let compareResult = date2.compare(date1)
            
            let interval = date2.timeIntervalSinceDate(date1)
            
            
            if interval > 300 {
                delay(3.0) {
                    self.updateScreen()
                }
            }else{
                actInd.hidden = true
                giftStatueNot.hidden = false
            }
            
            println("ads time compareResult = \(compareResult)")
            println("ads time interval = \(interval)")
            
            println("ads time compare = \(date1)")
            println("ads time check = \(date2)")
            
        }else {
            delay(3.0) {
                self.updateScreen()
            }
        }
    }
    
    func updateScreen() {
        
        UnityAds.sharedInstance().setViewController(self)
        UnityAds.sharedInstance().setZone("rewardedVideoZone")
        
        if UnityAds.sharedInstance().canShowAds(){
            actInd.hidden = true
            giftStatueNot.hidden = true
            redGift.hidden = false
            blueGift.hidden = false
            greenGift.hidden = false
        }else {
            actInd.hidden = true
            giftStatueNot.hidden = false
        }
    }
    
    
    func unityAdsVideoCompleted(rewardItemKey: String, skipped: Bool) -> Void {
        println("skip \(skipped)")
        if !skipped {
            
            var intCoins: Int = userSetting.integerForKey("myCoins")
            
            intCoins = intCoins + 20
            
            userSetting.setInteger(intCoins, forKey: "myCoins")
            
            userSetting.setObject(self.stateAds, forKey: "adsTime")
            
            self.redGift.hidden = true
            self.blueGift.hidden = true
            self.greenGift.hidden = true
            
            self.giftStatueNot.text = "Congratulations, Your got 20 coins from Gift, you current coins is \(intCoins)"
            self.delegate!.updateCoinsGift(String(userSetting.integerForKey("myCoins")))
            self.giftStatueNot.hidden = false
        }
    }
    
    @IBAction func slowLiftButton(sender: UIButton) {
        let slowGift = self.storyboard!.instantiateViewControllerWithIdentifier("getGift") as! GetGift
        slowGift.delegate = self
        
        self.navigationController?.pushViewController(slowGift, animated: true)
    }
    
    @IBAction func ads1(sender: UIButton) {
        openAds()
    }
    
    @IBAction func ads2(sender: UIButton) {
        openAds()
    }
    
    @IBAction func ads3(sender: UIButton) {
        openAds()
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func openAds() {
        
        var refreshAlert = UIAlertController(title: "Advertise", message: "See advertise for gift?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Watch", style: .Default, handler: { (action: UIAlertAction!) in
            
            let date = NSDate()
            self.stateAds = date
            
            UnityAds.sharedInstance().setViewController(self)
            UnityAds.sharedInstance().setZone("rewardedVideoZone")
            
            if UnityAds.sharedInstance().canShowAds(){
                UnityAds.sharedInstance().show()
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func disableGift(isTrue: Bool) {
        if isTrue == true {
            self.slowGift.enabled = false
            var coins = String(userSetting.integerForKey("myCoins"))
            self.delegate!.updateCoinsGift(coins)
        }
    }
}
