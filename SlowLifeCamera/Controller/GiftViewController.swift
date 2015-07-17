//
//  GiftViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/9/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit


class GiftViewController: UIViewController, UnityAdsDelegate {
    
    @IBOutlet weak var redGift: UIView!
    @IBOutlet weak var blueGift: UIView!
    @IBOutlet weak var greenGift: UIView!
    
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
        
    
    var currentLife: Int = 0
    
    var uiClick: UIButton!
    
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redGift.hidden = true
        blueGift.hidden = true
        greenGift.hidden = true
        
        let stateTime: AnyObject? = userSetting.objectForKey("adsTime")
        
        if stateTime != nil {
            var lastInt: Int = stateTime as! Int
            var dateFormatter = NSDateFormatter()
            
            let date = NSDate()
            var dateFormatter2 = NSDateFormatter()
            dateFormatter2.dateFormat = "yyyyMMddHHmm"
            let currentTime = dateFormatter2.stringFromDate(date)
            var saveTimeString = currentTime.toInt()
            
            var timeCheck = saveTimeString! - lastInt
            
            if timeCheck > 5 {
                let saveTime: Void = userSetting.setObject(saveTimeString!, forKey: "adsTime")
                UnityAds.sharedInstance().delegate = self
                UnityAds.sharedInstance().startWithGameId("51551")
                
                delay(3.0){
                    self.startTimer()
                }

            }
            println("ads time check = \(timeCheck)")
        }else {
            var dateFormatter = NSDateFormatter()
            let date = NSDate()
            dateFormatter.dateFormat = "yyyyMMddHHmm"
            let currentTime = dateFormatter.stringFromDate(date)
            var saveTimeString = currentTime.toInt()
            let saveTime: Void = userSetting.setObject(saveTimeString!, forKey: "adsTime")
            
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
            
            let randomNumber = arc4random_uniform(200)
            
            let randomCoins = Int(randomNumber)
            
            var intCoins: Int = userSetting.integerForKey("myCoins")
            
            intCoins = intCoins + randomCoins
            
            userSetting.setInteger(intCoins, forKey: "myCoins")
            
            println("Random coins = \(randomCoins)")
            println("new coins = \(intCoins)")
            
        }
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
