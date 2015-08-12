//
//  GetGift.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/16/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

protocol disableUI {
    func disableGift(isTrue: Bool)
}

class GetGift: UIViewController {
    let userSetting: NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    var delegate: disableUI? = nil
    
    @IBOutlet var randomLabel: UILabel!
    
    var randomCoins: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomNumber = arc4random_uniform(100) + 20
        self.randomCoins = Int(randomNumber)
        randomLabel.text = String(self.randomCoins)
    }
    
    @IBAction func getgift(sender: UIButton) {
        
        
        let randomNumber = arc4random_uniform(100) + 20
        var randomCoins = Int(randomNumber)
        
        var intCoins: Int = userSetting.integerForKey("myCoins")
        
        intCoins = intCoins + randomCoins
        
        userSetting.setInteger(intCoins, forKey: "myCoins")
        
        
        var dateFormatter = NSDateFormatter()
        let date = NSDate()
        
        userSetting.setObject(date, forKey: "lasttime")
        self.delegate?.disableGift(true)
        let alertController = UIAlertController(title: "Congratulations", message:
            "Your got \(randomCoins) coins from Slow Life Gift, you current coins is \(intCoins)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
            self.navigationController!.popViewControllerAnimated(true)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}