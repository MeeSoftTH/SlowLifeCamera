//
//  ShopViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/8/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

protocol updateFilm {
    func updateFilmUIView(isTrue: Bool)
}

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, updateCoins {
    @IBOutlet var myTableView: UITableView!
    var arryOfShopDatas:[ShopDatas] = [ShopDatas]()
     var getCoins = GetCoinsViewController()
    
    var update: updateFilm? = nil
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    @IBOutlet weak var myCoins: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let intCoins: Int = userSetting.integerForKey("myCoins")
        
        var myStringCoins = String(intCoins)
        
        myCoins.text = myStringCoins
        
        getCoins.delegate = self
        
        self.setUpShopDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buy(sender: UIButton) {
        
        let button = sender as UIButton
        let view = button.superview!
        let cell = view.superview as! ShopCustomCell
        let indexPath = self.myTableView.indexPathForCell(cell)
        
        println("This index = \(indexPath?.item)")
        
        var text = "CCtrlFilter"
        
        if indexPath?.item == 0 {
            text = "CCtrlFilter"
        }else if indexPath?.item == 1 {
            text = "SepiaFilter"
        }else if indexPath?.item == 2 {
            text = "ReduceNoiseFilter"
        }else if indexPath?.item == 3 {
            text = "MonoFilter"
        }else if indexPath?.item == 4 {
            text = "PolyFilter"
        }else if indexPath?.item == 5 {
            text = "FadeFilter"
        }else if indexPath?.item == 6 {
            text = "NormalFilter"
        }else if indexPath?.item == 7 {
            text = "SmallFilter"
        }
        
        var alert = UIAlertController(title: text, message: "Do you want to get \(text)?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.getFilter(indexPath!.item)
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getFilter(index: Int) {
        
        var datas = ["", "", 10]
        
        if index == 0 {
            datas = ["#01", "filter1", 10]
        }else if index == 1 {
            datas = ["#02", "filter2", 20]
        }else if index == 2 {
            datas = ["#03", "filter3", 40]
        }else if index == 3 {
            datas = ["#04", "filter4", 50]
        }else if index == 4 {
            datas = ["#05", "filter5", 80]
        }else if index == 5 {
            datas = ["#06", "filter6", 80]
        }else if index == 6 {
            datas = ["#07", "filter7", 80]
        }else if index == 7 {
            datas = ["#08", "filter8", 80]
        }
        
        
        for index in 1...9 {
            
            if index <= 8 {
                var intCoins: Int = self.userSetting.integerForKey("myCoins")
                
                var filmCoins = datas[2] as! Int
                
                if intCoins >= filmCoins {
                    
                    var poiter = "row\(index)"
                    var dataCheck: AnyObject? = self.userSetting.objectForKey(poiter)
                    var film = dataCheck!.objectAtIndex(4) as! Bool
                    if film == false {
                        var slotName = "Slot\(index)"
                        userSetting.setObject([slotName, datas[0], datas[1], 25, true], forKey: poiter)
                        
                        println("set slot name is = \(slotName)")
                        println("set to key is = \(poiter)")
                        println(self.userSetting.objectForKey(poiter))
                        
                        intCoins = intCoins - filmCoins
                        
                        self.myCoins.text = String(intCoins)
                        
                        userSetting.setInteger(intCoins, forKey: "myCoins")
                        
                        self.update?.updateFilmUIView(true)
                        
                        let alertController = UIAlertController(title: "Successfuly", message:
                            "Add to your bag successful", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        return
                    }
                }else {
                    let alertController = UIAlertController(title: "Not enough coins", message:
                        "You are not enough coins, Please refill frist!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil ))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else {
                
                let alertController = UIAlertController(title: "Status", message:
                    "Film in your bag is full, Please remove them", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
        }
    }
    
    func setUpShopDatas() {
        
        self.myTableView.rowHeight = 70
        
        var filmType1 = ShopDatas(iconName: "filter1", name: "CCtrlFilter", coins: 10)
        var filmType2 = ShopDatas(iconName: "filter2", name: "SepiaFilter", coins: 20)
        var filmType3 = ShopDatas(iconName: "filter3", name: "ReduceNoiseFilter", coins: 40)
        var filmType4 = ShopDatas(iconName: "filter4", name: "MonoFilter", coins: 50)
        
        var filmType5 = ShopDatas(iconName: "filter5", name: "PolyFilter", coins: 80)
        var filmType6 = ShopDatas(iconName: "filter6", name: "FadeFilter", coins: 80)
        var filmType7 = ShopDatas(iconName: "filter7", name: "NormalFilter", coins: 80)
        var filmType8 = ShopDatas(iconName: "filter8", name: "SmallFilter", coins: 80)
        
        arryOfShopDatas.append(filmType1)
        arryOfShopDatas.append(filmType2)
        arryOfShopDatas.append(filmType3)
        arryOfShopDatas.append(filmType4)
        
        arryOfShopDatas.append(filmType5)
        arryOfShopDatas.append(filmType6)
        arryOfShopDatas.append(filmType7)
        arryOfShopDatas.append(filmType8)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryOfShopDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ShopCustomCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ShopCustomCell
        
        let shopData = arryOfShopDatas[indexPath.row]
        cell.setCell(shopData.iconName, name: shopData.name, coins: shopData.coins)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let popupView = segue.destinationViewController as? UIViewController
        {
            if let popup = popupView.popoverPresentationController
            {
                popup.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        
        return UIModalPresentationStyle.None
    }
    
    func updateCoinsText(text: String){
        self.myCoins.text = text
    }
}
