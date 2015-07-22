//
//  ShopDatas.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/20/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import Foundation

class ShopDatas {
    
    var iconName = "filter1"
    var name = "Normal"
    var coins = 0
    
    init(iconName: String, name: String, coins: Int) {
    
        self.iconName = iconName
        self.name = name
        self.coins = coins
    }
}