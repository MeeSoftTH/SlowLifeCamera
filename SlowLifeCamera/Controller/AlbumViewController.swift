//
//  AlbumViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/20/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet var myTable: UITableView!
    
    var slot1: String = ""
    var slot2: String = ""
    var slot3: String = ""
    var slot4: String = ""
    
    var slot5: String = ""
    var slot6: String = ""
    var slot7: String = ""
    var slot8: String = ""
    
    var rowIndex: Int = 0
    
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    var arryOfAlbumDatas:[AlbumDatas] = [AlbumDatas]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpAlbumRow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpAlbumRow() {
        
        self.myTable.rowHeight = 70
        
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        var fileList = listFilesFromDocumentsFolder()
        
        let count = fileList.count
        var isDir:Bool = true;
        
        
        if count > 0 {
            for var i:Int = 0; i < count; i++
            {
                if fileManager.fileExistsAtPath(fileList[i]) != true
                {
                    println("File is \(fileList[i])")
                    let pointer = i + 1
                    let key = "Slot\(pointer)"
                    let slot: AnyObject? = userSetting?.objectForKey(key)
                    let folder = slot!.objectAtIndex(0) as! String
                    let filter = slot!.objectAtIndex(1) as! String
                    let icon = slot!.objectAtIndex(2) as! String
                    let number = slot!.objectAtIndex(3) as! String
                    
                    
                    var row = AlbumDatas(name: folder, filterName: filter, iconName: icon, number: number)
                    arryOfAlbumDatas.append(row)
                    
                    if pointer == 1 {
                        slot1 = key
                    }else if pointer == 2 {
                        slot2 = key
                    }else if pointer == 3 {
                        slot3 = key
                    }else if pointer == 4 {
                        slot4 = key
                    }else if pointer == 5 {
                        slot5 = key
                    }else if pointer == 6 {
                        slot6 = key
                    }else if pointer == 7 {
                        slot7 = key
                    }else if pointer == 8 {
                        slot8 = key
                    }
                }
            }
        }else {
            println("No file in directory")
        }
    }
    
    func listFilesFromDocumentsFolder() -> [String]
    {
        var theError = NSErrorPointer()
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if dirs != nil {
            let dir = dirs![0]
            let fileList = NSFileManager.defaultManager().contentsOfDirectoryAtPath("\(dir)/CompletedData", error: theError)
            return fileList as! [String]
        }else{
            let fileList = [""]
            return fileList
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryOfAlbumDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AlbumCustomCell = tableView.dequeueReusableCellWithIdentifier("albumCell") as! AlbumCustomCell
        
        let AlbumData = arryOfAlbumDatas[indexPath.row]
        cell.setAlbumCell(AlbumData.name, filterName: AlbumData.filterName, iconName: AlbumData.iconName, number: AlbumData.number)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        rowIndex = indexPath.row
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewControllerWithIdentifier("imageGallery") as! PhotoGalleryViewController
        self.navigationController!.pushViewController(newVC, animated: true)
        
        if rowIndex == 0 {
            newVC.keySlot = self.slot1
        } else if rowIndex == 1 {
            newVC.keySlot = self.slot2
        } else if rowIndex == 2 {
            newVC.keySlot = self.slot3
        } else if rowIndex == 3 {
            newVC.keySlot = self.slot4
        } else if rowIndex == 4 {
            newVC.keySlot = self.slot5
        } else if rowIndex == 5 {
            newVC.keySlot = self.slot6
        } else if rowIndex == 6 {
            newVC.keySlot = self.slot7
        } else if rowIndex == 7 {
            newVC.keySlot = self.slot8
        }
    }
    
    
}