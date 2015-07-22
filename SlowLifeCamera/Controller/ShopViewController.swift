//
//  ShopViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/8/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet var myTableView: UITableView!
    var arryOfShopDatas:[ShopDatas] = [ShopDatas]()
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    @IBOutlet weak var myCoins: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let intCoins: Int = userSetting.integerForKey("myCoins")
        
        var myStringCoins = String(intCoins)
        
        myCoins.text = myStringCoins
        
        self.setUpShopDatas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpShopDatas() {
        
        self.myTableView.rowHeight = 70
    
        var filmType1 = ShopDatas(iconName: "filter1", name: "", coins: 50)
        var filmType2 = ShopDatas(iconName: "filter2", name: "", coins: 50)
        var filmType3 = ShopDatas(iconName: "filter3", name: "", coins: 50)
        var filmType4 = ShopDatas(iconName: "filter4", name: "", coins: 50)
        
        var filmType5 = ShopDatas(iconName: "filter5", name: "", coins: 50)
        var filmType6 = ShopDatas(iconName: "filter6", name: "", coins: 50)
        var filmType7 = ShopDatas(iconName: "filter7", name: "", coins: 50)
        var filmType8 = ShopDatas(iconName: "filter8", name: "", coins: 50)
        
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

}
