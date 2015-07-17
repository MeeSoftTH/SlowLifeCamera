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
    
    
    @IBOutlet weak var getButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stateTime: AnyObject? = userSetting.objectForKey("lasttime")
        
        if stateTime != nil {
            var lastInt: Int = stateTime as! Int
            var dateFormatter = NSDateFormatter()
            
            let date = NSDate()
            var dateFormatter2 = NSDateFormatter()
            dateFormatter2.dateFormat = "yyyyMMddHHmm"
            let currentTime = dateFormatter2.stringFromDate(date)
            var saveTimeString = currentTime.toInt()
            
            var timeCheck = saveTimeString! - lastInt
            
            if timeCheck > 600 {
                let saveTime: Void = userSetting.setObject(saveTimeString!, forKey: "lasttime")
                getButton.hidden = false
            }
            println("time check = \(timeCheck)")
        }else {
            var dateFormatter = NSDateFormatter()
            let date = NSDate()
            dateFormatter.dateFormat = "yyyyMMddHHmm"
            let currentTime = dateFormatter.stringFromDate(date)
            var saveTimeString = currentTime.toInt()
            let saveTime: Void = userSetting.setObject(saveTimeString!, forKey: "lasttime")
            
            getButton.hidden = false
            println("button enable = \(getButton.hidden)")
        }
        
    }
    
    
    
    @IBAction func getgift(sender: UIButton) {
        var intCoins: Int = userSetting.integerForKey("myCoins")
        
        intCoins = intCoins + 50
        
        userSetting.setInteger(intCoins, forKey: "myCoins")
        
        navigationController!.popViewControllerAnimated(true)
    }
    
    
}
