//
//  GetGift.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/16/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class GetGift: UIViewController {
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getgift(sender: UIButton) {
        
        let randomNumber = arc4random_uniform(100) + 20
        
        let randomCoins = Int(randomNumber)
        
        var intCoins: Int = userSetting.integerForKey("myCoins")
        
        intCoins = intCoins + randomCoins
        
        userSetting.setInteger(intCoins, forKey: "myCoins")
        
        
        var dateFormatter = NSDateFormatter()
        let date = NSDate()
        
        userSetting.setObject(date, forKey: "lasttime")
        
        
        delay(0.5){
            let alertController = UIAlertController(title: "Congratulations", message:
                "Your got \(randomCoins) coins from Slow Lift Gift, you current coins is \(intCoins)", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}