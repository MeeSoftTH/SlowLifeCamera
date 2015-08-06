//
//  ShopViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/8/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit
import StoreKit

protocol updateFilm {
    func updateFilmUIViewAndCoins(isTrue: Bool, myCoins: String)
}

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet var myTableView: UITableView!
    var arryOfShopDatas:[ShopDatas] = [ShopDatas]()
    
    var update: updateFilm? = nil
    
    let userSetting: NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var myCoins: UILabel!
    
    let groupId: String = "th.co.meesoft.slowlifecamera"
    let get150: String = "th.co.meesoft.slowlifecamera.coins150"
    let get320: String = "th.co.meesoft.slowlifecamera.coins320"
    let get500: String = "th.co.meesoft.slowlifecamera.coins500"
    let get1000: String = "th.co.meesoft.slowlifecamera.coins1000"
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let intCoins: Int = userSetting.integerForKey("myCoins")
        
        var myStringCoins = String(intCoins)
        
        myCoins.text = myStringCoins
        
        let myNum = count(myStringCoins)
        
        if myNum <= 3 {
            self.myCoins.frame.size.width = 40
        }else  if myNum > 3 && myNum < 5{
            self.myCoins.frame.size.width = 58
        }else if myNum >= 5 {
            self.myCoins.frame.size.width = 73
        }
        
        self.setUpShopDatas()
        preloadPurchase(get150)
        preloadPurchase(get320)
        preloadPurchase(get500)
        preloadPurchase(get1000)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getMoreCoins(sender: UIButton) {
        
        var chooseDialog = UIAlertController(title: "Get more coins", message: "Choose you want coins?",preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        chooseDialog.addAction(UIAlertAction(title: "150 coins - $0.99", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.alertDialog(self.get150)
        }))
        
        chooseDialog.addAction(UIAlertAction(title: "320 coins - $1.99", style: .Default, handler: { (action: UIAlertAction!) in
            self.alertDialog(self.get320)
        }))
        
        chooseDialog.addAction(UIAlertAction(title: "500 coins - $2.99", style: .Default, handler: { (action: UIAlertAction!) in
            self.alertDialog(self.get500)
        }))
        
        
        chooseDialog.addAction(UIAlertAction(title: "1000 coins - $3.99", style: .Default, handler: { (action: UIAlertAction!) in
            self.alertDialog(self.get1000)
        }))
        
        chooseDialog.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(chooseDialog, animated: true, completion: nil)
        
        
    }
    
    @IBAction func buy(sender: UIButton) {
        
        let button = sender as UIButton
        let view = button.superview!
        let cell = view.superview as! ShopCustomCell
        let indexPath = self.myTableView.indexPathForCell(cell)
        
        println("This index = \(indexPath?.item)")
        
        var text = "No.14"
        
        if indexPath?.item == 0 {
            text = "No.14"
        }else if indexPath?.item == 1 {
            text = "Sepia"
        }else if indexPath?.item == 2 {
            text = "Mono"
        }else if indexPath?.item == 3 {
            text = "No.10"
        }else if indexPath?.item == 4 {
            text = "Poly"
        }else if indexPath?.item == 5 {
            text = "No.9"
        }else if indexPath?.item == 6 {
            text = "No.7"
        }else if indexPath?.item == 7 {
            text = "No.13"
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
        
        for var index = 1; index < 9; index++ {
            
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
                        println("Index is = \(index)")
                        println(self.userSetting.objectForKey(poiter))
                        index = 10
                        
                        intCoins = intCoins - filmCoins
                        
                        self.myCoins.text = String(intCoins)
                        
                        var myStringCoins = String(intCoins)
                        
                        myCoins.text = myStringCoins
                        
                        let myNum = count(myStringCoins)
                        
                        if myNum <= 3 {
                            self.myCoins.frame.size.width = 40
                        }else  if myNum > 3 && myNum < 5{
                            self.myCoins.frame.size.width = 58
                        }else if myNum >= 5 {
                            self.myCoins.frame.size.width = 73
                        }

                        
                        self.userSetting.setInteger(intCoins, forKey: "myCoins")
                        
                        let currentMyCoins = String(self.userSetting.integerForKey("myCoins"))
                        
                        self.update?.updateFilmUIViewAndCoins(true, myCoins: currentMyCoins)

                        
                        let alertController = UIAlertController(title: "Successfuly", message:
                            "Add to your bag successful", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
                        }))
                        
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
                
            }
        }
    }
    
    func setUpShopDatas() {
        
        self.myTableView.rowHeight = 70
        
        var filmType1 = ShopDatas(iconName: save.variable.iconFilter1, name: save.variable.filter1, coins: 10)
        var filmType2 = ShopDatas(iconName: save.variable.iconFilter2, name: save.variable.filter2, coins: 20)
        var filmType3 = ShopDatas(iconName: save.variable.iconFilter3, name: save.variable.filter3, coins: 40)
        var filmType4 = ShopDatas(iconName: save.variable.iconFilter4, name: save.variable.filter4, coins: 50)
        
        var filmType5 = ShopDatas(iconName: save.variable.iconFilter5, name: save.variable.filter5, coins: 80)
        var filmType6 = ShopDatas(iconName: save.variable.iconFilter6, name: save.variable.filter6, coins: 80)
        var filmType7 = ShopDatas(iconName: save.variable.iconFilter7, name: save.variable.filter7, coins: 80)
        var filmType8 = ShopDatas(iconName: save.variable.iconFilter8, name: save.variable.filter8, coins: 80)
        
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
    
    func preloadPurchase(productId: String) {
        
        if(SKPaymentQueue.canMakePayments()) {
            println("IAP is enabled, loading")
            var productID:NSSet = NSSet(objects: productId)
            var request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            println("please enable IAPS")
        }
        
        return
    }
    
    func alertDialog(productId: String) {
        
        var alertText = ["", ""]
        
        if productId == self.get150 {
            alertText = ["$0.99", "150"]
            
        }else if productId == self.get320{
            alertText = ["$1.99", "320"]
            
        }else if productId == self.get500 {
            alertText = ["$2.99", "500"]
            
        }else if productId == self.get1000 {
            alertText = ["$3.99", "1000"]
            
        }
        
        var alert = UIAlertController(title: "Get coins", message: "Do you want to pay \(alertText[0]) for \(alertText[1]) coins?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            
            for product in self.list {
                var prodID = product.productIdentifier
                if(prodID == productId) {
                    self.p = product
                    self.makePurchase()
                    break;
                }
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // Purchase function
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func makePurchase() {
        println("purchasing: " + p.productIdentifier)
        var pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println("product request")
        var myProduct = response.products
        
        for product in myProduct {
            println("product added")
            println(product.productIdentifier)
            println(product.localizedTitle)
            println(product.localizedDescription)
            println(product.price)
            
            list.append(product as! SKProduct)
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        for transaction:AnyObject in transactions {
            var trans = transaction as! SKPaymentTransaction
            println(trans.error)
            
            switch trans.transactionState {
            case .Purchased:
                
                
                println("Buying success: Unlock features.")
                println(p.productIdentifier)
                
                
                var productIndex = String()
                if self.index == 0 {
                    productIndex = self.get150
                    
                }else if self.index == 1{
                    productIndex = self.get320
                    
                }else if self.index == 2 {
                    productIndex = self.get500
                    
                }else if self.index == 3 {
                    productIndex = self.get1000
                    
                }
                
                let prodID = p.productIdentifier as String
                if(prodID == productIndex){
                    
                    var intCoins: Int = userSetting.integerForKey("myCoins")
                    
                    if self.index == 0 {
                        
                        intCoins = intCoins +  150
                        
                    }else if self.index == 1{
                        intCoins = intCoins + 320
                        
                    }else if self.index == 2 {
                        intCoins = intCoins + 500
                        
                    }else if self.index == 3 {
                        intCoins = intCoins + 1000
                        
                    }
                    
                    self.myCoins.text = String(intCoins)
                    
                    var myStringCoins = String(intCoins)
                    
                    myCoins.text = myStringCoins
                    
                    let myNum = count(myStringCoins)
                    
                    if myNum <= 3 {
                        self.myCoins.frame.size.width = 40
                    }else  if myNum > 3 && myNum < 5{
                        self.myCoins.frame.size.width = 58
                    }else if myNum >= 5 {
                        self.myCoins.frame.size.width = 73
                    }

                    
                    self.userSetting.setInteger(intCoins, forKey: "myCoins")
                    
                    let currentMyCoins = String(userSetting.integerForKey("myCoins"))
                    
                    self.update?.updateFilmUIViewAndCoins(false, myCoins: currentMyCoins)
                    
                    println("current coins = \(intCoins)")
                    
                }
                
                queue.finishTransaction(trans)
                break;
            case .Failed:
                println("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                println("default")
                break;
                
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction){
        println("finish trans")
        SKPaymentQueue.defaultQueue().finishTransaction(trans)
    }
    
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!){
        println("remove trans");
    }
}
