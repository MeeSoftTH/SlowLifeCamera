//
//  MyBagViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/6/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class MyBagViewController: UIViewController, updateFilm {
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    @IBOutlet weak var film1b: UIButton!
    @IBOutlet weak var num1: UILabel!
    
    
    @IBOutlet weak var film2b: UIButton!
    @IBOutlet weak var num2: UILabel!
    
    
    @IBOutlet weak var film3b: UIButton!
    @IBOutlet weak var num3: UILabel!
    
    
    @IBOutlet weak var film4b: UIButton!
    @IBOutlet weak var num4: UILabel!
    
    
    @IBOutlet weak var film5b: UIButton!
    @IBOutlet weak var num5: UILabel!
    
    
    @IBOutlet weak var film6b: UIButton!
    @IBOutlet weak var num6: UILabel!
    
    
    @IBOutlet weak var film7b: UIButton!
    @IBOutlet weak var num7: UILabel!
    
    
    @IBOutlet weak var film8b: UIButton!
    @IBOutlet weak var num8: UILabel!
    
    let slotName1: String = "row1"
    let slotName2: String = "row2"
    let slotName3: String = "row3"
    let slotName4: String = "row4"
    
    let slotName5: String = "row5"
    let slotName6: String = "row6"
    let slotName7: String = "row7"
    let slotName8: String = "row8"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func shopping(sender: AnyObject) {
        let selectView = self.storyboard!.instantiateViewControllerWithIdentifier("shop") as! ShopViewController
        
        //let selectView: OptionView = OptionView()
        selectView.update = self
       self.navigationController?.pushViewController(selectView, animated: true)
    }
    
    @IBAction func slot1(sender: UIButton) {
        let film: AnyObject? = userSetting?.objectForKey(slotName1)
        save.variable.key = slotName1
        choicesDialog(film!)
    }
    
    @IBAction func slot2(sender: UIButton) {
        let film: AnyObject? = userSetting?.objectForKey(slotName2)
        save.variable.key = slotName2
        choicesDialog(film!)
    }
    
    @IBAction func slot3(sender: UIButton) {
        let film: AnyObject? = userSetting?.objectForKey(slotName3)
        save.variable.key = slotName3
        choicesDialog(film!)
        
    }
    
    @IBAction func slot4(sender: UIButton) {
        let film: AnyObject? = userSetting?.objectForKey(slotName4)
        save.variable.key = slotName4
        choicesDialog(film!)
    }
    
    
    @IBAction func slot5(sender: UIButton) {
        let film: AnyObject? = userSetting?.objectForKey(slotName5)
        save.variable.key = slotName5
        choicesDialog(film!)
    }
    
    @IBAction func slot6(sender: UIButton) {
        let film: AnyObject? = userSetting?.objectForKey(slotName6)
        save.variable.key = slotName6
        choicesDialog(film!)
    }
    
    @IBAction func slot7(sender: UIButton) {
        let film: AnyObject? = userSetting?.objectForKey(slotName7)
        save.variable.key = slotName7
        choicesDialog(film!)
    }
    
    @IBAction func slot8(sender: UIButton) {
        let film: AnyObject? = userSetting?.objectForKey(slotName8)
        save.variable.key = slotName8
        choicesDialog(film!)
    }
    
    func updateControl() {
        
        let film1: AnyObject? = userSetting?.objectForKey(slotName1)
        var film1Bool = film1!.objectAtIndex(4) as! Bool
        if film1Bool == true {
            var film1Text = film1!.objectAtIndex(3) as! Int
            num1.text = String(film1Text) + (" of 25")
            
            var filmImg1 = film1!.objectAtIndex(2) as! String
            
            println(filmImg1)
            
            self.film1b!.setImage(UIImage(named: filmImg1), forState: UIControlState.Normal)
            
        }else {
            self.film1b!.setImage(UIImage(named: "slotLocked"), forState: UIControlState.Normal)
            num1.text = ""
            
        }
        
        let film2: AnyObject? = userSetting?.objectForKey(slotName2)
        var film2Bool = film2!.objectAtIndex(4) as! Bool
        if film2Bool == true {
            var film2Text = film2!.objectAtIndex(3) as! Int
            num2.text = String(film2Text) + (" of 25")
            
            var filmImg2 = film2!.objectAtIndex(2) as! NSString
            
            self.film2b!.setImage(UIImage(named: filmImg2 as String), forState: UIControlState.Normal)
        }else {
            self.film2b!.setImage(UIImage(named: "slotLocked"), forState: UIControlState.Normal)
            num2.text = ""
            
        }
        
        let film3: AnyObject? = userSetting?.objectForKey(slotName3)
        var film3Bool = film3!.objectAtIndex(4) as! Bool
        if film3Bool == true {
            var film3Text = film3!.objectAtIndex(3) as! Int
            num3.text = String(film3Text) + (" of 25")
            
            var filmImg3 = film3!.objectAtIndex(2) as! NSString
            
            self.film3b!.setImage(UIImage(named: filmImg3 as String), forState: UIControlState.Normal)
        }else {
            self.film3b!.setImage(UIImage(named: "slotLocked"), forState: UIControlState.Normal)
            num3.text = ""
            
        }
        
        let film4: AnyObject? = userSetting?.objectForKey(slotName4)
        var film4Bool = film4!.objectAtIndex(4) as! Bool
        if film4Bool == true {
            var film4Text = film4!.objectAtIndex(3) as! Int
            num4.text = String(film4Text) + (" of 25")
            
            var filmImg4 = film4!.objectAtIndex(2) as! NSString
            
            self.film4b!.setImage(UIImage(named: filmImg4 as String), forState: UIControlState.Normal)
        }else {
            self.film4b!.setImage(UIImage(named: "slotLocked"), forState: UIControlState.Normal)
            num4.text = ""
            
        }
        
        
        
        let film5: AnyObject? = userSetting?.objectForKey(slotName5)
        var film5Bool = film5!.objectAtIndex(4) as! Bool
        if film5Bool == true {
            var film5Text = film5!.objectAtIndex(3) as! Int
            num5.text = String(film5Text) + (" of 25")
            
            var filmImg5 = film5!.objectAtIndex(2) as! NSString
            
            self.film5b!.setImage(UIImage(named: filmImg5 as String), forState: UIControlState.Normal)
        }else {
            self.film5b!.setImage(UIImage(named: "slotLocked"), forState: UIControlState.Normal)
            num5.text = ""
            
        }
        
        let film6: AnyObject? = userSetting?.objectForKey(slotName6)
        var film6Bool = film6!.objectAtIndex(4) as! Bool
        if film6Bool == true {
            var film6Text = film6!.objectAtIndex(3) as! Int
            num6.text = String(film6Text) + (" of 25")
            
            var filmImg6 = film6!.objectAtIndex(2) as! NSString
            
            self.film6b!.setImage(UIImage(named: filmImg6 as String), forState: UIControlState.Normal)
        }else {
            self.film6b!.setImage(UIImage(named: "slotLocked"), forState: UIControlState.Normal)
            num6.text = ""
            
        }
        
        let film7: AnyObject? = userSetting?.objectForKey(slotName7)
        var film7Bool = film7!.objectAtIndex(4) as! Bool
        if film7Bool == true {
            var film7Text = film7!.objectAtIndex(3) as! Int
            num7.text = String(film7Text) + (" of 25")
            
            var filmImg7 = film7!.objectAtIndex(2) as! NSString
            
            self.film7b!.setImage(UIImage(named: filmImg7 as String), forState: UIControlState.Normal)
        }else {
            self.film7b!.setImage(UIImage(named: "slotLocked"), forState: UIControlState.Normal)
            num7.text = ""
            
        }
        
        let film8: AnyObject? = userSetting?.objectForKey(slotName8)
        var film8Bool = film8!.objectAtIndex(4) as! Bool
        if film8Bool == true {
            var film8Text = film8!.objectAtIndex(3) as! Int
            num8.text = String(film8Text) + (" of 25")
            
            var filmImg8 = film8!.objectAtIndex(2) as! NSString
            
            self.film8b!.setImage(UIImage(named: filmImg8 as String), forState: UIControlState.Normal)
        }else {
            self.film8b!.setImage(UIImage(named: "slotLocked"), forState: UIControlState.Normal)
            num8.text = ""
            
        }
        
        self.film1b?.enabled = film1Bool
        self.film2b?.enabled = film2Bool
        self.film3b?.enabled = film3Bool
        self.film4b?.enabled = film4Bool
        
        self.film5b?.enabled = film5Bool
        self.film6b?.enabled = film6Bool
        self.film7b?.enabled = film7Bool
        self.film8b?.enabled = film8Bool
    }
    
    
    func choicesDialog(filmRow:AnyObject?){
        
        let number = filmRow!.objectAtIndex(3) as! Int
        
        var chooseDialog = UIAlertController(title: "Options", message: "Choose your action?",preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        if number < 25 {
            chooseDialog.addAction(UIAlertAction(title: "Conver to photos", style: .Default, handler: { (action: UIAlertAction!) in
                
                var refreshAlert = UIAlertController(title: "Converter", message: "Do you want convert photo with filter?", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                    if filmRow != nil {
                        var filterSlot = filmRow!.objectAtIndex(1) as! String
                        var keySlot = filmRow!.objectAtIndex(0) as! String
                        
                        let filterView = self.storyboard!.instantiateViewControllerWithIdentifier("process") as! FilterViewController
                        
                        filterView.keySlot = keySlot
                        filterView.keyFilter = filterSlot
                        
                        self.presentViewController(filterView, animated: true, completion: nil)
                    }
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
                    println("Handle Cancel Logic here")
                }))
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
                
            }))
        }
        
        if number > 0 {
            chooseDialog.addAction(UIAlertAction(title: "Use this film", style: .Default, handler: { (action: UIAlertAction!) in
                if filmRow != nil {
                    var filmNum = filmRow!.objectAtIndex(3) as! Int
                    save.variable.myNum = filmNum
                    save.variable.rowSlected = true
                    var slotName = filmRow!.objectAtIndex(0) as! String
                    
                    initial().createSubDirectory("RawData", subDir: slotName)
                    
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
        }
        
        chooseDialog.addAction(UIAlertAction(title: "Delete this film", style: .Default, handler: { (action: UIAlertAction!) in
            
            var alert = UIAlertController(title: "Delete film", message: "Do you want delete this film?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                if filmRow != nil {
                    var slot = filmRow!.objectAtIndex(0) as! NSString
                    
                    self.userSetting.setObject(["", "", "", 10, false], forKey: save.variable.key)
                    
                    self.updateControl()
                }}))
            
            alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
                println("Handle Cancel Logic here")
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }))
        
        chooseDialog.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(chooseDialog, animated: true, completion: nil)
    }
    
    @IBAction func cameraView(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateFilmUIView(isTrue: Bool) {
        if isTrue == true {
            updateControl()
        }
    }
    
}
