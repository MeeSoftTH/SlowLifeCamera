//
//  ShopCustomCell.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/20/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class ShopCustomCell: UITableViewCell {
    @IBOutlet var iconName: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var coinsLabel: UILabel!
   
    
    func setCell(iconName: String, name: String, coins: Int) {
        self.iconName.image = UIImage(named: iconName)
        self.nameLabel.text = name
        self.coinsLabel.text = String(coins)
    }
    
    
    @IBAction func buyFilter(sender: UIButton) {
    }
    
}
