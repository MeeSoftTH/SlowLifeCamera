//
//  AlbumCustomCell.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/20/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class AlbumCustomCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var filterName: UILabel!
    @IBOutlet var iconName: UIImageView!
    @IBOutlet var number: UILabel!
    
    func setAlbumCell(name: String, filterName: String, iconName: String, number: String) {
        self.iconName.image = UIImage(named: iconName)
        self.name.text = name
        self.filterName.text = filterName
        self.number.text = number == "1" ? "\(number) photo" : "\(number) photos"
    }
    
}
