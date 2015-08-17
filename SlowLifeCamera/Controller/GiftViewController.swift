//
//  GiftViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/9/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit
import AVFoundation

protocol updateCoins {
    func updateCoinsGift(myCoins: String)
}

class GiftViewController: UIViewController, AVAudioPlayerDelegate, UnityAdsDelegate {
    
    @IBOutlet weak var slowGift: UIButton!
    @IBOutlet weak var redGift: UIView!
    @IBOutlet weak var blueGift: UIView!
    @IBOutlet weak var greenGift: UIView!
    
    @IBOutlet var actInd: UIActivityIndicatorView!
    @IBOutlet var giftStatueNot: UILabel!
    
    let userSetting: NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    var uiClick: UIButton!
    var timer: NSTimer!
    var stateAds = NSDate()
    var stateGift = NSDate()
    var numberTime: Int = 0
    
    var soundPlayer:AVAudioPlayer!
    
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
                timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateScreen"), userInfo: nil, repeats: true)
            }
            else{
                self.actInd.hidden = true
                self.giftStatueNot.hidden = false
            }
            
            println("ads time interval = \(interval)")
            
            println("ads time compare = \(date1)")
            println("ads time check = \(date2)")
            
        }else {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateScreen"), userInfo: nil, repeats: true)
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
            
            self.timer.invalidate()
            self.timer = nil
            
            println("Stop Timer")
            
        }else {
            if self.numberTime > 10 {
                self.timer.invalidate()
                self.timer = nil
                actInd.hidden = true
                giftStatueNot.hidden = false
                self.numberTime = 0
                println("Stop Timer")
            }
            self.numberTime++
        }
    }
    
    
    func unityAdsVideoCompleted(rewardItemKey: String, skipped: Bool) -> Void {
        println("skip \(skipped)")
        if !skipped {
            
            delay(3.0) {
                self.audioPlayer()
                var intCoins: Int = self.userSetting.integerForKey("myCoins")
                let alertController = UIAlertController(title: "Congratulations", message:
                    "Your got 20 coins from Slow Life Gift, you current coins is \(intCoins)", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
                    
                    //self.giftStatueNot.text = "Congratulations, Your got 20 coins from Gift, you current coins is \(intCoins)"
                    
                    self.giftStatueNot.hidden = false
                    
                    intCoins = intCoins + 20
                    self.userSetting.setInteger(intCoins, forKey: "myCoins")
                    
                    self.userSetting.setObject(self.stateAds, forKey: "adsTime")
                    self.delegate!.updateCoinsGift(String(self.userSetting.integerForKey("myCoins")))
                    self.redGift.hidden = true
                    self.blueGift.hidden = true
                    self.greenGift.hidden = true
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func slowLiftButton(sender: UIButton) {
        
        let randomNumber = arc4random_uniform(9) + 1
        var randomCoins:Int = Int(randomNumber)
        
        println("RandomCoins is= \(String(randomCoins))")
        
        if randomCoins < 2 {
            randomCoins = 2
        }
        
        randomCoins = randomCoins * 10
        
        var intCoins: Int = userSetting.integerForKey("myCoins")
        
        intCoins = intCoins + randomCoins
        
        userSetting.setInteger(intCoins, forKey: "myCoins")
        
        
        var dateFormatter = NSDateFormatter()
        let date = NSDate()
        
        userSetting.setObject(date, forKey: "lasttime")
        
        self.audioPlayer()
        
        let alertController = UIAlertController(title: "Congratulations", message:
            "Your got \(randomCoins) coins from Slow Life Gift, you current coins is \(intCoins)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
            
            self.slowGift.enabled = false
            var coins = String(self.userSetting.integerForKey("myCoins"))
            self.delegate!.updateCoinsGift(coins)
            
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
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
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func audioPlayer() {
        var error: NSError?
        
        let resourcePath = NSBundle.mainBundle().URLForResource("effect", withExtension: "WAV")!
        
        soundPlayer = AVAudioPlayer(contentsOfURL: resourcePath, error: nil)
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        if !session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error:&error) {
            println("could not set output to speaker")
            if let e = error {
                println(e.localizedDescription)
            }
        }

        
        if let err = error {
            println("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            println("AVAudioPlayer Play: \(resourcePath)")
            soundPlayer.stop()
            soundPlayer.delegate = self
            soundPlayer.volume = 1.0
            soundPlayer.prepareToPlay()
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            soundPlayer.play()
            
        }
    }
    
}
