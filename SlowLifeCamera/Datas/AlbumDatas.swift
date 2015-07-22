//
//  AlbumDatas.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/20/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import Foundation

class AlbumDatas {
    
    var name = "Name"
    var filterName = "filterName"
    var iconName = "filter"
    var number = "number"
    
    init(name: String, filterName: String, iconName: String, number: String) {
        self.iconName = iconName
        self.name = name
        self.filterName = filterName
        self.number = number
    }
}