//
//  MyBagViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/6/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class MyBagViewController: UIViewController {
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    @IBOutlet weak var myCoins: UILabel!
    
    @IBOutlet weak var film1: UIButton!
    @IBOutlet weak var num1: UILabel!
    
    
    @IBOutlet weak var film2: UIButton!
    @IBOutlet weak var num2: UILabel!
    
    
    @IBOutlet weak var film3: UIButton!
    @IBOutlet weak var num3: UILabel!
    
    
    @IBOutlet weak var film4: UIButton!
    @IBOutlet weak var num4: UILabel!
    
    
    @IBOutlet weak var film5: UIButton!
    @IBOutlet weak var num5: UILabel!
    
    
    @IBOutlet weak var film6: UIButton!
    @IBOutlet weak var num6: UILabel!
    
    
    @IBOutlet weak var film7: UIButton!
    @IBOutlet weak var num7: UILabel!
    
    
    @IBOutlet weak var film8: UIButton!
    @IBOutlet weak var num8: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateControl()
        
        film1.enabled = userSetting.boolForKey("slot1")
        film2.enabled = userSetting.boolForKey("slot2")
        film3.enabled = userSetting.boolForKey("slot3")
        film4.enabled = userSetting.boolForKey("slot4")
        
        film5.enabled = userSetting.boolForKey("slot5")
        film6.enabled = userSetting.boolForKey("slot6")
        film7.enabled = userSetting.boolForKey("slot7")
        film8.enabled = userSetting.boolForKey("slot8")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func slot1(sender: UIButton) {
        let film1: AnyObject? = userSetting?.objectForKey("film1")
        save.variable.key = "film1"
        choicesDialog(film1!)
    }
    
    @IBAction func slot2(sender: UIButton) {
        let film2: AnyObject? = userSetting?.objectForKey("film2")
        choicesDialog(film2!)
    }
    
    @IBAction func slot3(sender: UIButton) {
        let film3: AnyObject? = userSetting?.objectForKey("film3")
        choicesDialog(film3!)
    }
    
    @IBAction func slot4(sender: UIButton) {
        let film4: AnyObject? = userSetting?.objectForKey("film4")
        choicesDialog(film4!)
    }
    
    @IBAction func slot5(sender: UIButton) {
        
        confirmDilog("slot5")
    
    }
    
    @IBAction func slot6(sender: UIButton) {
        
        confirmDilog("slot6")
    }
    
    @IBAction func slot7(sender: UIButton) {
        
        confirmDilog("slot7")
        
    }
    
    @IBAction func slot8(sender: UIButton) {
        
        confirmDilog("slot8")
        
    }
    
    
    func updateControl() {
        
        let intCoins: Int = userSetting.integerForKey("myCoins")
        
        var myStringCoins = String(intCoins)
        
        myCoins.text = myStringCoins
        
        let film1: AnyObject? = userSetting?.objectForKey("film1")
        if film1 != nil {
            var text2 = film1!.objectAtIndex(1) as! NSNumber
            
            num1.text = text2.stringValue + ("/10")
        }
        
        let film2: AnyObject? = userSetting?.objectForKey("film2")
        if film2 != nil {
            var text2 = film2!.objectAtIndex(1) as! NSNumber
            num2.text = text2.stringValue + ("/10")
        }
        
        let film3: AnyObject? = userSetting?.objectForKey("film3")
        if film3 != nil {
            var text2 = film3!.objectAtIndex(1) as! NSNumber
            num3.text = text2.stringValue + ("/10")
        }
        
        let film4: AnyObject? = userSetting?.objectForKey("film4")
        if film4 != nil {
            var text2 = film4!.objectAtIndex(1) as! NSNumber
            num4.text = text2.stringValue + ("/10")
        }
        
        let film5: AnyObject? = userSetting?.objectForKey("film5")
        if film5 != nil {
            var text2 = film5!.objectAtIndex(1) as! NSNumber
            num5.text = text2.stringValue + ("/10")
        }
        
        let film6: AnyObject? = userSetting?.objectForKey("film6")
        if film6 != nil {
            var text2 = film6!.objectAtIndex(1) as! NSNumber
            num6.text = text2.stringValue + ("/10")
        }
        
        let film7: AnyObject? = userSetting?.objectForKey("film7")
        if film7 != nil {
            var text2 = film7!.objectAtIndex(1) as! NSNumber
            num7.text = text2.stringValue + ("/10")
        }
        
        let film8: AnyObject? = userSetting?.objectForKey("film8")
        if film8 != nil {
            var text2 = film8!.objectAtIndex(1) as! NSNumber
            num8.text = text2.stringValue + ("/10")
        }
    }
    
    
    func choicesDialog(filmRow:AnyObject?){
        
        var chooseDialog = UIAlertController(title: "Options", message: "Choose your action?",preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        chooseDialog.addAction(UIAlertAction(title: "Conver to photos", style: .Default, handler: { (action: UIAlertAction!) in
            
            
        }))
        
        chooseDialog.addAction(UIAlertAction(title: "Use", style: .Default, handler: { (action: UIAlertAction!) in
            
            if filmRow != nil {
                var filmId = filmRow!.objectAtIndex(0) as! Int
                var filmNum = filmRow!.objectAtIndex(1) as! Int
              save.variable.myNum = filmNum
                var error: NSError?
                
                var filmDir = String(filmId)
                
                let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                let documentsDirectory: AnyObject = paths[0]
                let dataPath = documentsDirectory.stringByAppendingPathComponent(filmDir)
                
                if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
                    NSFileManager.defaultManager() .createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil, error: &error)
                }
                
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        chooseDialog.addAction(UIAlertAction(title: "Trash", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        
        chooseDialog.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(chooseDialog, animated: true, completion: nil)
    }
    
    
    func confirmDilog(key: String){
        
        var confirmDilog = UIAlertController(title: "", message: "Confirm is you get this filter!",preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        confirmDilog.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
            
            
            self.userSetting.setBool(true, forKey : key)
            
        }))
        
        confirmDilog.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(confirmDilog, animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func cameraView(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
