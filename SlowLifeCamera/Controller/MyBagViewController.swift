//
//  MyBagViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/6/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class MyBagViewController: UIViewController, updateFilm, removeFilm, updateCoins, updateLabel, updateCoinsViewPhoto {
    
    let userSetting: NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
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
    
    
    @IBOutlet var buttonView1: UIView!
    @IBOutlet var buttonView2: UIView!
    @IBOutlet var buttonView3: UIView!
    @IBOutlet var buttonView4: UIView!
    
    @IBOutlet var buttonView5: UIView!
    @IBOutlet var buttonView6: UIView!
    @IBOutlet var buttonView7: UIView!
    @IBOutlet var buttonView8: UIView!
    
    @IBOutlet var myCoins: UILabel!
    
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
        
        DataSetting.variable.controller = self
        
        self.myCoins.text = String(userSetting.integerForKey("myCoins"))
        
        let myNum = count(String(userSetting.integerForKey("myCoins")))
        
        if myNum < 3 {
            self.myCoins.frame.size.width = 48
        }else  if myNum >= 3 && myNum < 5{
            self.myCoins.frame.size.width = 58
        }else if myNum >= 5 {
            self.myCoins.frame.size.width = 78
        }
        
        println("\(self.myCoins.frame.size.width)")
        
        updateControl()
        defineButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        MyBagViewController().navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewDidAppear(animated)
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
    
    @IBAction func giftButton(sender: AnyObject) {
        
        let GiftView = self.storyboard!.instantiateViewControllerWithIdentifier("gift") as! GiftViewController
        GiftView.delegate = self
        self.navigationController?.pushViewController(GiftView, animated: true)
    }
    
    @IBAction func cameraButton(sender: AnyObject) {
        if DataSetting.variable.rowSlected == true {
            let cameraView = self.storyboard!.instantiateViewControllerWithIdentifier("cameraView") as! CameraController
            cameraView.delegate = self
            
            self.presentViewController(cameraView, animated: true, completion: nil)
        }else {
            let alertController = UIAlertController(title: "Select film first", message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func tap1() {
        let film: AnyObject? = userSetting?.objectForKey(slotName1)
        DataSetting.variable.key = slotName1
        DataSetting.variable.filmIndex = 1
        self.isSelect(buttonView1)
        useFilm(film!)
        println("Tap happend")
    }
    
    func longTap1() {
        let film: AnyObject? = userSetting?.objectForKey(slotName1)
        DataSetting.variable.key = slotName1
        DataSetting.variable.filmIndex = 1
        self.isSelect(buttonView1)
        choicesDialog(film!)
        println("Long press")
    }
    
    func tap2() {
        let film: AnyObject? = userSetting?.objectForKey(slotName2)
        DataSetting.variable.key = slotName2
        DataSetting.variable.filmIndex = 2
        self.isSelect(buttonView2)
        useFilm(film!)
        println("Tap happend")
    }
    
    func longTap2() {
        let film: AnyObject? = userSetting?.objectForKey(slotName2)
        DataSetting.variable.key = slotName2
        DataSetting.variable.filmIndex = 2
        self.isSelect(buttonView2)
        choicesDialog(film!)
        println("Long press")
    }
    
    func tap3() {
        let film: AnyObject? = userSetting?.objectForKey(slotName3)
        DataSetting.variable.key = slotName3
        DataSetting.variable.filmIndex = 3
        self.isSelect(buttonView3)
        useFilm(film!)
        println("Tap happend")
    }
    
    func longTap3() {
        let film: AnyObject? = userSetting?.objectForKey(slotName3)
        DataSetting.variable.key = slotName3
        DataSetting.variable.filmIndex = 3
        self.isSelect(buttonView3)
        choicesDialog(film!)
        println("Long press")
    }
    
    func tap4() {
        let film: AnyObject? = userSetting?.objectForKey(slotName4)
        DataSetting.variable.key = slotName4
        DataSetting.variable.filmIndex = 4
        self.isSelect(buttonView4)
        useFilm(film!)
        println("Tap happend")
    }
    
    func longTap4() {
        let film: AnyObject? = userSetting?.objectForKey(slotName4)
        DataSetting.variable.key = slotName4
        DataSetting.variable.filmIndex = 4
        self.isSelect(buttonView4)
        choicesDialog(film!)
        println("Long press")
    }
    
    func tap5() {
        let film: AnyObject? = userSetting?.objectForKey(slotName5)
        DataSetting.variable.key = slotName5
        DataSetting.variable.filmIndex = 5
        self.isSelect(buttonView5)
        useFilm(film!)
        println("Tap happend")
    }
    
    func longTap5() {
        let film: AnyObject? = userSetting?.objectForKey(slotName5)
        DataSetting.variable.key = slotName5
        DataSetting.variable.filmIndex = 5
        self.isSelect(buttonView5)
        choicesDialog(film!)
        println("Long press")
    }
    
    func tap6() {
        let film: AnyObject? = userSetting?.objectForKey(slotName6)
        DataSetting.variable.key = slotName6
        DataSetting.variable.filmIndex = 6
        self.isSelect(buttonView6)
        useFilm(film!)
        println("Tap happend")
    }
    
    func longTap6() {
        let film: AnyObject? = userSetting?.objectForKey(slotName6)
        DataSetting.variable.key = slotName6
        DataSetting.variable.filmIndex = 6
        self.isSelect(buttonView6)
        choicesDialog(film!)
        println("Long press")
    }
    
    func tap7() {
        let film: AnyObject? = userSetting?.objectForKey(slotName7)
        DataSetting.variable.key = slotName7
        DataSetting.variable.filmIndex = 7
        self.isSelect(buttonView7)
        useFilm(film!)
        println("Tap happend")
    }
    
    func longTap7() {
        let film: AnyObject? = userSetting?.objectForKey(slotName7)
        DataSetting.variable.key = slotName7
        DataSetting.variable.filmIndex = 7
        self.isSelect(buttonView7)
        choicesDialog(film!)
        println("Long press")
    }
    
    func tap8() {
        let film: AnyObject? = userSetting?.objectForKey(slotName8)
        DataSetting.variable.key = slotName8
        DataSetting.variable.filmIndex = 8
        self.isSelect(buttonView8)
        useFilm(film!)
        println("Tap happend")
    }
    
    func longTap8() {
        let film: AnyObject? = userSetting?.objectForKey(slotName8)
        DataSetting.variable.key = slotName8
        DataSetting.variable.filmIndex = 8
        self.isSelect(buttonView8)
        choicesDialog(film!)
        println("Long press")
    }
    
    
    func defineButton() {
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: "tap1")
        let longGesture1 = UILongPressGestureRecognizer(target: self, action: "longTap1")
        tapGesture1.numberOfTapsRequired = 1
        film1b.addGestureRecognizer(tapGesture1)
        film1b.addGestureRecognizer(longGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: "tap2")
        let longGesture2 = UILongPressGestureRecognizer(target: self, action: "longTap2")
        tapGesture2.numberOfTapsRequired = 1
        film2b.addGestureRecognizer(tapGesture2)
        film2b.addGestureRecognizer(longGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: "tap3")
        let longGesture3 = UILongPressGestureRecognizer(target: self, action: "longTap3")
        tapGesture3.numberOfTapsRequired = 1
        film3b.addGestureRecognizer(tapGesture3)
        film3b.addGestureRecognizer(longGesture3)
        
        let tapGesture4 = UITapGestureRecognizer(target: self, action: "tap4")
        let longGesture4 = UILongPressGestureRecognizer(target: self, action: "longTap4")
        tapGesture4.numberOfTapsRequired = 1
        film4b.addGestureRecognizer(tapGesture4)
        film4b.addGestureRecognizer(longGesture4)
        
        
        let tapGesture5 = UITapGestureRecognizer(target: self, action: "tap5")
        let longGesture5 = UILongPressGestureRecognizer(target: self, action: "longTap5")
        tapGesture5.numberOfTapsRequired = 1
        film5b.addGestureRecognizer(tapGesture5)
        film5b.addGestureRecognizer(longGesture5)
        
        let tapGesture6 = UITapGestureRecognizer(target: self, action: "tap6")
        let longGesture6 = UILongPressGestureRecognizer(target: self, action: "longTap6")
        tapGesture6.numberOfTapsRequired = 1
        film6b.addGestureRecognizer(tapGesture6)
        film6b.addGestureRecognizer(longGesture6)
        
        let tapGesture7 = UITapGestureRecognizer(target: self, action: "tap7")
        let longGesture7 = UILongPressGestureRecognizer(target: self, action: "longTap7")
        tapGesture7.numberOfTapsRequired = 1
        film7b.addGestureRecognizer(tapGesture7)
        film7b.addGestureRecognizer(longGesture7)
        
        let tapGesture8 = UITapGestureRecognizer(target: self, action: "tap8")
        let longGesture8 = UILongPressGestureRecognizer(target: self, action: "longTap8")
        tapGesture8.numberOfTapsRequired = 1
        film8b.addGestureRecognizer(tapGesture8)
        film8b.addGestureRecognizer(longGesture8)
        
    }
    
    func isSelect(view: UIView) {
        
        self.buttonView1.backgroundColor = UIColor.clearColor()
        self.buttonView2.backgroundColor = UIColor.clearColor()
        self.buttonView3.backgroundColor = UIColor.clearColor()
        self.buttonView4.backgroundColor = UIColor.clearColor()
        
        self.buttonView5.backgroundColor = UIColor.clearColor()
        self.buttonView6.backgroundColor = UIColor.clearColor()
        self.buttonView7.backgroundColor = UIColor.clearColor()
        self.buttonView8.backgroundColor = UIColor.clearColor()
        
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.brownColor()
        
    }
    
    func updateControl() {
        let film1: AnyObject? = userSetting?.objectForKey(slotName1)
        var film1Bool = film1!.objectAtIndex(4) as! Bool
        if film1Bool == true {
            var film1Text = film1!.objectAtIndex(3) as! Int
            
            var film1TextLength = film1!.objectAtIndex(4) as! Int
            
            num1.text = String(film1Text) + (" of \(String(film1TextLength))")
            
            var filmImg1 = film1!.objectAtIndex(2) as! String
            
            self.film1b!.setImage(UIImage(named: filmImg1), forState: UIControlState.Normal)
            
        }else {
            self.film1b!.setImage(UIImage(named: "slotLocked"), forState: UIControlState.Normal)
            num1.text = ""
            
        }
        
        let film2: AnyObject? = userSetting?.objectForKey(slotName2)
        var film2Bool = film2!.objectAtIndex(4) as! Bool
        if film2Bool == true {
            var film2Text = film2!.objectAtIndex(3) as! Int
            
            var film2TextLength = film2!.objectAtIndex(4) as! Int
            
            num2.text = String(film2Text) + (" of \(String(film2TextLength))")
            
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
            
            var film3TextLength = film3!.objectAtIndex(4) as! Int
            
            num3.text = String(film3Text) + (" of \(String(film3TextLength))")
            
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
            
            var film4TextLength = film4!.objectAtIndex(4) as! Int
            
            num4.text = String(film4Text) + (" of \(String(film4TextLength))")
            
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
            
            var film5TextLength = film5!.objectAtIndex(4) as! Int
            
            num5.text = String(film5Text) + (" of \(String(film5TextLength))")
            
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
            
            var film6TextLength = film6!.objectAtIndex(4) as! Int
            
            num6.text = String(film6Text) + (" of \(String(film6TextLength))")
            
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
            
            var film7TextLength = film7!.objectAtIndex(4) as! Int
            
            num7.text = String(film7Text) + (" of \(String(film7TextLength))")
            
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
            
            var film8TextLength = film8!.objectAtIndex(4) as! Int
            
            num8.text = String(film8Text) + (" of \(String(film8TextLength))")
            
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
    
    
    func useFilm(filmRow:AnyObject?){
        
        let keyFilterName = filmRow!.objectAtIndex(1) as! String
        
        var nameText: String = ""
        
        if keyFilterName == "#01" {
            nameText = DataSetting.variable.filter1
            
        }else if keyFilterName == "#02" {
            nameText = DataSetting.variable.filter2
            
        }else if keyFilterName == "#03" {
            nameText = DataSetting.variable.filter3
            
        }else if keyFilterName == "#04" {
            nameText = DataSetting.variable.filter4
            
        }else if keyFilterName == "#05" {
            nameText = DataSetting.variable.filter5
            
        }else if keyFilterName == "#06" {
            nameText = DataSetting.variable.filter6
            
        }else if keyFilterName == "#07" {
            nameText = DataSetting.variable.filter7
            
        }else if keyFilterName == "#08" {
            nameText = DataSetting.variable.filter8
            
        }
        
        
        if filmRow != nil {
            var filmNum = filmRow!.objectAtIndex(3) as! Int
            
            if filmNum > 0 {
                DataSetting.variable.myNum = filmNum
                DataSetting.variable.rowSlected = true
                var slotName = filmRow!.objectAtIndex(0) as! String
                
                GlobalFunction().createSubDirectory("RawData", subDir: slotName)
                
            }else if filmNum == 0 {
                
                var refreshAlert = UIAlertController(title: "Develop", message: "Develop \(nameText) film?", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Develop", style: .Default, handler: { (action: UIAlertAction!) in
                    let filterView = self.storyboard!.instantiateViewControllerWithIdentifier("process") as! FilterViewController
                    filterView.delegate = self
                    self.presentViewController(filterView, animated: true, completion: nil)
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    
    func choicesDialog(filmRow:AnyObject?){
        
        let number = filmRow!.objectAtIndex(3) as! Int
        var filmNumLength = filmRow!.objectAtIndex(4) as! Int
        
        let keyFilterName = filmRow!.objectAtIndex(1) as! String
        
        
        var nameText: String = ""
        
        if keyFilterName == "#01" {
            nameText = DataSetting.variable.filter1
            
        }else if keyFilterName == "#02" {
            nameText = DataSetting.variable.filter2
            
        }else if keyFilterName == "#03" {
            nameText = DataSetting.variable.filter3
            
        }else if keyFilterName == "#04" {
            nameText = DataSetting.variable.filter4
            
        }else if keyFilterName == "#05" {
            nameText = DataSetting.variable.filter5
            
        }else if keyFilterName == "#06" {
            nameText = DataSetting.variable.filter6
            
        }else if keyFilterName == "#07" {
            nameText = DataSetting.variable.filter7
            
        }else if keyFilterName == "#08" {
            nameText = DataSetting.variable.filter8
            
        }
        
        
        var chooseDialog = UIAlertController(title: "Choose your action for", message: nameText ,preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        if number < filmNumLength {
            chooseDialog.addAction(UIAlertAction(title: "Develop this film?", style: .Default, handler: { (action: UIAlertAction!) in
                
                let filterView = self.storyboard!.instantiateViewControllerWithIdentifier("process") as! FilterViewController
                filterView.delegate = self
                self.presentViewController(filterView, animated: true, completion: nil)
                
            }))
        }
        
        chooseDialog.addAction(UIAlertAction(title: "Delete this film", style: .Default, handler: { (action: UIAlertAction!) in
            
            var alert = UIAlertController(title: "Delete film", message: "Do you want delete \(nameText) film?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                if filmRow != nil {
                    var slot = filmRow!.objectAtIndex(0) as! NSString
                    
                    self.userSetting.setObject(["", "", "", 0, false], forKey: DataSetting.variable.key)
                    
                    self.updateControl()
                    
                    DataSetting.variable.filmIndex = 0
                    self.buttonView1.backgroundColor = UIColor.clearColor()
                    self.buttonView2.backgroundColor = UIColor.clearColor()
                    self.buttonView3.backgroundColor = UIColor.clearColor()
                    self.buttonView4.backgroundColor = UIColor.clearColor()
                    
                    self.buttonView5.backgroundColor = UIColor.clearColor()
                    self.buttonView6.backgroundColor = UIColor.clearColor()
                    self.buttonView7.backgroundColor = UIColor.clearColor()
                    self.buttonView8.backgroundColor = UIColor.clearColor()
                    
                    println("Set to key = \(slot)")
                    
                    let removeDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    
                    let removeIndexDir: AnyObject = removeDir[0]
                    
                    var removePath = removeIndexDir.stringByAppendingPathComponent("RawData/\(slot)")
                    
                    let fileDir = NSFileManager.defaultManager()
                    var removeErrorrror: NSError?
                    
                    if fileDir.removeItemAtPath(removePath, error: &removeErrorrror) {
                        println("\(removePath) = Remove Dir successful")
                    } else {
                        println("Remove failed: \(removeErrorrror!.localizedDescription)")
                    }
                    
                }}))
            
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: { (action: UIAlertAction!) in
                
                self.buttonView1.backgroundColor = UIColor.clearColor()
                self.buttonView2.backgroundColor = UIColor.clearColor()
                self.buttonView3.backgroundColor = UIColor.clearColor()
                self.buttonView4.backgroundColor = UIColor.clearColor()
                
                self.buttonView5.backgroundColor = UIColor.clearColor()
                self.buttonView6.backgroundColor = UIColor.clearColor()
                self.buttonView7.backgroundColor = UIColor.clearColor()
                self.buttonView8.backgroundColor = UIColor.clearColor()
                
                 DataSetting.variable.rowSlected = false
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }))
        
        chooseDialog.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
            
        }))
        presentViewController(chooseDialog, animated: true, completion: nil)
    }
    
    func updateFilmUIViewAndCoins(isTrue: Bool, myCoins: String) {
        if isTrue == true {
            updateControl()
        }
        
        self.myCoins.text = myCoins
    }
    
    func removeAfterSuccess(isTrue: Bool) {
        if isTrue == true {
            updateControl()
            DataSetting.variable.filmIndex = 0
            self.buttonView1.backgroundColor = UIColor.clearColor()
            self.buttonView2.backgroundColor = UIColor.clearColor()
            self.buttonView3.backgroundColor = UIColor.clearColor()
            self.buttonView4.backgroundColor = UIColor.clearColor()
            
            self.buttonView5.backgroundColor = UIColor.clearColor()
            self.buttonView6.backgroundColor = UIColor.clearColor()
            self.buttonView7.backgroundColor = UIColor.clearColor()
            self.buttonView8.backgroundColor = UIColor.clearColor()
        }
    }
    
    
    func updateCoinsGift(myCoins: String) {
        self.myCoins.text = myCoins
        
        let myNum = count(String(userSetting.integerForKey("myCoins")))
        
        if myNum < 3 {
            self.myCoins.frame.size.width = 48
        }else  if myNum >= 3 && myNum < 5{
            self.myCoins.frame.size.width = 58
        }else if myNum >= 5 {
            self.myCoins.frame.size.width = 78
        }
    }
    
    func updateLabelCamera(text: String, isDev: Bool) {
        
        println("Update label")
        var nameText: String = ""
        var keyFilterName: String = ""
        var buttonUI: UIView = self.buttonView1
        
        if DataSetting.variable.filmIndex == 1 {
            let film: AnyObject? = userSetting?.objectForKey(slotName1)
            var filmLength = film!.objectAtIndex(4) as! Int
            self.num1.text = ("\(text) of \(filmLength)")
            keyFilterName = film!.objectAtIndex(1) as! String
            DataSetting.variable.key = slotName1
            buttonUI = self.buttonView1
            
        }else if DataSetting.variable.filmIndex == 2 {
            let film: AnyObject? = userSetting?.objectForKey(slotName2)
            var filmLength = film!.objectAtIndex(4) as! Int
            self.num2.text = ("\(text) of \(filmLength)")
            keyFilterName = film!.objectAtIndex(1) as! String
            DataSetting.variable.key = slotName2
            buttonUI = self.buttonView2
            
        }else if DataSetting.variable.filmIndex == 3 {
            let film: AnyObject? = userSetting?.objectForKey(slotName3)
            var filmLength = film!.objectAtIndex(4) as! Int
            self.num3.text = ("\(text) of \(filmLength)")
            keyFilterName = film!.objectAtIndex(1) as! String
            DataSetting.variable.key = slotName3
            buttonUI = self.buttonView3
            
        }else if DataSetting.variable.filmIndex == 4 {
            let film: AnyObject? = userSetting?.objectForKey(slotName4)
            var filmLength = film!.objectAtIndex(4) as! Int
            self.num4.text = ("\(text) of \(filmLength)")
            keyFilterName = film!.objectAtIndex(1) as! String
            DataSetting.variable.key = slotName4
            buttonUI = self.buttonView4
            
        }else if DataSetting.variable.filmIndex == 5 {
            let film: AnyObject? = userSetting?.objectForKey(slotName5)
            var filmLength = film!.objectAtIndex(4) as! Int
            self.num5.text = ("\(text) of \(filmLength)")
            keyFilterName = film!.objectAtIndex(1) as! String
            DataSetting.variable.key = slotName5
            buttonUI = self.buttonView5
            
        }else if DataSetting.variable.filmIndex == 6 {
            let film: AnyObject? = userSetting?.objectForKey(slotName6)
            var filmLength = film!.objectAtIndex(4) as! Int
            self.num6.text = ("\(text) of \(filmLength)")
            keyFilterName = film!.objectAtIndex(1) as! String
            DataSetting.variable.key = slotName6
            buttonUI = self.buttonView6
            
        }else if DataSetting.variable.filmIndex == 7 {
            let film: AnyObject? = userSetting?.objectForKey(slotName7)
            var filmLength = film!.objectAtIndex(4) as! Int
            self.num7.text = ("\(text) of \(filmLength)")
            keyFilterName = film!.objectAtIndex(1) as! String
            DataSetting.variable.key = slotName7
            buttonUI = self.buttonView7
            
        }else if DataSetting.variable.filmIndex == 8 {
            let film: AnyObject? = userSetting?.objectForKey(slotName8)
            var filmLength = film!.objectAtIndex(4) as! Int
            self.num8.text = ("\(text) of \(filmLength)")
            keyFilterName = film!.objectAtIndex(1) as! String
            DataSetting.variable.key = slotName8
            buttonUI = self.buttonView8
            
        }
        if isDev == true {
            self.isSelect(buttonUI)
            
            if keyFilterName == "#01" {
                nameText = DataSetting.variable.filter1
                
            }else if keyFilterName == "#02" {
                nameText = DataSetting.variable.filter2
                
            }else if keyFilterName == "#03" {
                nameText = DataSetting.variable.filter3
                
            }else if keyFilterName == "#04" {
                nameText = DataSetting.variable.filter4
                
            }else if keyFilterName == "#05" {
                nameText = DataSetting.variable.filter5
                
            }else if keyFilterName == "#06" {
                nameText = DataSetting.variable.filter6
                
            }else if keyFilterName == "#07" {
                nameText = DataSetting.variable.filter7
                
            }else if keyFilterName == "#08" {
                nameText = DataSetting.variable.filter8
                
            }
            println("Alert Develop film")
            
            delay(1.0){
                
                var refreshAlert = UIAlertController(title: "Develop", message: "Develop \(nameText) film?", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Develop", style: .Default, handler: { (action: UIAlertAction!) in
                    let filterView = self.storyboard!.instantiateViewControllerWithIdentifier("process") as! FilterViewController
                    filterView.delegate = self
                    self.presentViewController(filterView, animated: true, completion: nil)
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    
    func updateCoinsViewPhoto2(coins: Int){
        
        var myString = String(coins)
        
        userSetting.setInteger(coins, forKey: "myCoins")
        
        let myNum = count(String(userSetting.integerForKey("myCoins")))
        
        self.myCoins.text = myString
        
        if myNum < 3 {
            self.myCoins.frame.size.width = 48
        }else  if myNum >= 3 && myNum < 5 {
            self.myCoins.frame.size.width = 58
        }else if myNum >= 5 {
            self.myCoins.frame.size.width = 78
        }
        
        println("MyCoins Label Update \(myString)")
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}
