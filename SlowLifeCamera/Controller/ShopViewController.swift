//
//  ShopViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/8/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var myCoins: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let intCoins: Int = save.variable.myCoins
        
        var myStringCoins = String(intCoins)
        
        myCoins.text = myStringCoins
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
