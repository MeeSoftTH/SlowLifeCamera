//
//  GiftViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/9/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit


class GiftViewController: UIViewController, UnityAdsDelegate {
    
    @IBOutlet weak var slowGift: UIButton!
    @IBOutlet weak var redGift: UIView!
    @IBOutlet weak var blueGift: UIView!
    @IBOutlet weak var greenGift: UIView!
    
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    var uiClick: UIButton!
    var timer: NSTimer!
    var stateAds = NSDate()
    var stateGift = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stateLast: AnyObject? = userSetting.objectForKey("lasttime")
        if stateLast != nil {
            let date = NSDate()
            
            let date1 : NSDate = stateLast as! NSDate
            let date2 : NSDate = date
            
            let compareResult = date1.compare(date2)
            
            let interval = date1.timeIntervalSinceDate(date2)
            
            
            if interval > 21600 {
                slowGift.enabled = true
            }
            println("time check = \(interval)")
        }else {
            let date = NSDate()
            
            self.stateGift = date
            
            slowGift.enabled = true
            println("button enable = \(slowGift.enabled)")
        }
        
        redGift.hidden = true
        blueGift.hidden = true
        greenGift.hidden = true
        
        let stateTime: AnyObject? = userSetting.objectForKey("adsTime")
        if stateTime != nil {
            
            let date = NSDate()
            
            var date1 : NSDate = stateTime as! NSDate
            var date2 : NSDate = date

            let compareResult = date2.compare(date1)
            
            let interval = date2.timeIntervalSinceDate(date1)
            
            
            if interval > 300 {
                UnityAds.sharedInstance().delegate = self
                UnityAds.sharedInstance().startWithGameId("51551")
                
                delay(3.0){
                    self.startTimer()
                }

            }
            
            println("ads time compareResult = \(compareResult)")
            println("ads time interval = \(interval)")
            
            println("ads time compare = \(date1)")
            println("ads time check = \(date2)")
            
        }else {
            let date = NSDate()
            
            self.stateAds = date
            
            UnityAds.sharedInstance().delegate = self
            UnityAds.sharedInstance().startWithGameId("51551")
            
            delay(3.0){
                self.startTimer()
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func startTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("updateScreen"), userInfo: nil, repeats: true)
    }
    
    func updateScreen() {
        
        UnityAds.sharedInstance().setViewController(self)
        UnityAds.sharedInstance().setZone("rewardedVideoZone")
        
        if UnityAds.sharedInstance().canShowAds(){
            redGift.hidden = false
            blueGift.hidden = false
            greenGift.hidden = false
        self.stop()
        }
    }
    
    func stop() {
        println("stop timer")
        self.timer.invalidate()
    }

    
    func unityAdsVideoCompleted(rewardItemKey: String, skipped: Bool) -> Void{
        println("skip \(skipped)")
        if !skipped {
            
            redGift.hidden = true
            blueGift.hidden = true
            greenGift.hidden = true
            
            let randomNumber = arc4random_uniform(150)
            
            let randomCoins = Int(randomNumber)
            
            var intCoins: Int = userSetting.integerForKey("myCoins")
            
            intCoins = intCoins + randomCoins
            
            userSetting.setInteger(intCoins, forKey: "myCoins")
            
            userSetting.setObject(self.stateAds, forKey: "adsTime")
            
            println("Random coins = \(randomCoins)")
            println("new coins = \(intCoins)")
            
        }
    }
    @IBAction func slowLiftButton(sender: UIButton) {
        
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
    
    func openAds() {
        
        UnityAds.sharedInstance().setViewController(self)
        UnityAds.sharedInstance().setZone("rewardedVideoZone")
        
        if UnityAds.sharedInstance().canShowAds(){
            UnityAds.sharedInstance().show()
        }
    }
    
    func hideView() {
    
    }
}
