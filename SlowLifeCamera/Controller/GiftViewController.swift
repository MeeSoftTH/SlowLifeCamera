//
//  GiftViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/9/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit


class GiftViewController: UIViewController, UnityAdsDelegate {
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    @IBOutlet weak var button1: UIButton! 
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    
    var currentLife: Int = 0
    
    var uiClick: UIButton!
    
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UnityAds.sharedInstance().delegate = self
        UnityAds.sharedInstance().startWithGameId("5155")
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateScreen"), userInfo: nil, repeats: true)
        
    }
    
    func updateScreen() {
        
        UnityAds.sharedInstance().setViewController(self)
        UnityAds.sharedInstance().setZone("rewardedVideoZone")
        
        if UnityAds.sharedInstance().canShowAds(){
            
            button1.enabled = true
            button2.enabled = true
            button3.enabled = true
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
            updateUserInterface(uiClick)
            var intCoins: Int = userSetting.integerForKey("myCoins")
            
            intCoins = intCoins + 50
            
            userSetting.setInteger(intCoins, forKey: "myCoins")
            
            
        }
    }
    
    @IBAction func ads1(sender: UIButton) {
        openAds(button1)
    }
    
    @IBAction func ads2(sender: UIButton) {
        openAds(button2)
    }
    
    @IBAction func ads3(sender: UIButton) {
        openAds(button3)
    }
    
    func openAds(button: UIButton) {
        
        uiClick = button
        
        UnityAds.sharedInstance().setViewController(self)
        UnityAds.sharedInstance().setZone("rewardedVideoZone")
        
        if UnityAds.sharedInstance().canShowAds(){
            UnityAds.sharedInstance().show()
        }
    }
    
    func updateUserInterface(button: UIButton) {
        
        if button.enabled == true {
            button.enabled = false
        }else {
            button.enabled = true
        }
    }
}
