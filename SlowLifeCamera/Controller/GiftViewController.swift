//
//  GiftViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/9/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class CustomCell : UITableViewCell {
   
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var get: UIButton!
    
    
    func loadItem(nameTitle: String, coinsTitle: String, image: String) {
        imageIcon.image = UIImage(named: image)
        coins.text = coinsTitle
        name.text = nameTitle
    }
}

extension Array {
    func each(callback: T -> ()) {
        for item in self {
            callback(item)
        }
    }
    
    func eachWithIndex(callback: (T, Int) -> ()) {
        var index = 0
        for item in self {
            callback(item, index)
            index += 1
        }
    }
}


class GiftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var giftTable: UITableView!
    
    var items: [(String, String, String)] = [
        ("Gift", "50", "film.png"),
        ("Sponser", "50", "film.png"),
        ("Sponser", "50", "film.png"),
        ("Sponser", "50", "film.png")
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var GiftViewController = self
        
        addEffects()
        
        var nib = UINib(nibName: "CustomCell", bundle: nil)
        
        giftTable.registerNib(nib, forCellReuseIdentifier: "customCell")
    }
    
    func addEffects() {
        [
            UIBlurEffectStyle.Light,
            UIBlurEffectStyle.Dark,
            UIBlurEffectStyle.ExtraLight
            ].map {
                UIBlurEffect(style: $0)
            }.eachWithIndex { (effect, index) in
                var effectView = UIVisualEffectView(effect: effect)
                
                effectView.frame = CGRectMake(0, CGFloat(50 * index), 320, 50)
                
                self.view.addSubview(effectView)
        }
    }
    
    func tableView(giftTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(giftTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomCell = giftTable.dequeueReusableCellWithIdentifier("customCell") as! CustomCell
        
        var (nameTitle, coinsTitle, image) = items[indexPath.row]
        
        cell.loadItem(nameTitle, coinsTitle: coinsTitle, image: image)
        
        return cell
    }
    
    func tableView(giftTable: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        giftTable.deselectRowAtIndexPath(indexPath, animated: true)
        println("You selected cell #\(indexPath.row)!")
    }
}
