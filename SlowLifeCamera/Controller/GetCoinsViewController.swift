//
//  GetCoinsViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/23/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit
import StoreKit

protocol updateCoins {
    func updateCoinsText(text: String)
}

class GetCoinsViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var delegate: updateCoins? = nil
    @IBOutlet var myCoise: UILabel!
    
    let groupId: String = "th.co.meesoft.slowlifecamera"
    
    let get150: String = "th.co.meesoft.slowlifecamera.coins150"
    let get320: String = "th.co.meesoft.slowlifecamera.coins320"
    let get500: String = "th.co.meesoft.slowlifecamera.coins500"
    let get1000: String = "th.co.meesoft.slowlifecamera.coins1000"
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var intCoins: Int = userSetting.integerForKey("myCoins")
        self.myCoise.text = String(intCoins)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        println("done")
    }
    
    @IBAction func buttonIndex0(sender: UIButton) {
        self.index = 0
        preloadPurchase(get150)
        delay(1.0) {
            self.alertDialog()
        }
    }
    
    @IBAction func buttonIndex1(sender: UIButton) {
        self.index = 1
        preloadPurchase(get320)
        delay(1.0) {
            self.alertDialog()
        }
    }
    
    @IBAction func buttonIndex2(sender: UIButton) {
        self.index = 2
        preloadPurchase(get500)
        delay(1.0) {
            self.alertDialog()
        }
    }
    
    @IBAction func buttonIndex3(sender: UIButton) {
        self.index = 3
        preloadPurchase(get1000)
        delay(1.0) {
            self.alertDialog()
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
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
    
    
    func alertDialog() {
        
        var alertText = ["", ""]
        
        if self.index == 0 {
            alertText = ["$0.99", "150"]
            
        }else if self.index == 1{
            alertText = ["$1.99", "320"]
            
        }else if self.index == 2 {
            alertText = ["$2.99", "500"]
            
        }else if self.index == 3 {
            alertText = ["$3.99", "1000"]
            
        }
        
        var alert = UIAlertController(title: "Get coins", message: "Do you want to pay \(alertText[0]) for \(alertText[1]) coins?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            
            var productId = String()
            
            if self.index == 0 {
                productId = self.get150
                
            }else if self.index == 1{
                productId = self.get320
                
            }else if self.index == 2 {
                productId = self.get500
                
            }else if self.index == 3 {
                productId = self.get1000
                
            }
            
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
                    
                    self.myCoise.text = String(intCoins)
                    
                    self.userSetting.setInteger(intCoins, forKey: "myCoins")
                    
                    println("current coins = \(intCoins)")
                    
                    self.delegate?.updateCoinsText(String(intCoins))
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
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}
