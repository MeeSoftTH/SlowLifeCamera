//
//  AlbumViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/20/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var myTable: UITableView!
    @IBOutlet var noLabel: UILabel!
    
    var publicKeyArray = [String]()
    
    var rowIndex: Int = 0
    
    let userSetting: NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    var arryOfAlbumDatas:[AlbumDatas] = [AlbumDatas]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setUpAlbumRow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        println("done")
    }
    
    func setUpAlbumRow() {
        
        self.myTable.rowHeight = 70
        
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        var fileList = listFilesFromDocumentsFolder()
        
        let count = fileList.count
        var isDir:Bool = true;
        
        
        if count > 0 {
            releaseMemory()
            
            self.publicKeyArray = fileList
            
            for var i:Int = 0; i < count; i++
            {
                if fileManager.fileExistsAtPath(fileList[i]) != true
                {
                    
                    println("This item = \(fileList[i])")
                    let key = String(fileList[i])
                    let slot: AnyObject? = userSetting?.objectForKey(key)
                    println("This key = \(key)")
                    
                    let folder = slot!.objectAtIndex(0) as! String
                    let filter = slot!.objectAtIndex(1) as! String
                    let icon = slot!.objectAtIndex(2) as! String
                    let number = slot!.objectAtIndex(3) as! String
                    
                    
                    if folder != "" &&  filter != "" && icon != "" && number != ""{
                        println("File is \(userSetting?.objectForKey(key))")
                        
    
                        var row = AlbumDatas(name: folder, filterName: filter, iconName: icon, number: number)
                        arryOfAlbumDatas.append(row)
                    }
                }
            }
            self.myTable.hidden = false
            self.noLabel.hidden = true
        }else {
            println("No file in directory")
            self.myTable.hidden = true
            self.noLabel.hidden = false
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
        releaseMemory()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        rowIndex = indexPath.row
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewControllerWithIdentifier("imageGallery") as! PhotoGalleryViewController
        self.navigationController!.pushViewController(newVC, animated: true)
      
        newVC.keySlot = self.publicKeyArray[indexPath.row]
        
        println("Call this = \( newVC.keySlot)")
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            arryOfAlbumDatas.removeAtIndex(indexPath.row)
        
            println("indexPath.row = \(indexPath.row)")
            
                    var fileList = listFilesFromDocumentsFolder()
                    println("Dir is = \(fileList[indexPath.row])")
                    self.removeDir(fileList[indexPath.row])
            
            self.myTable.reloadData()
        }
    }
    
    func removeDir(fileName: String) {
        
        println("File name = \(fileName)")
        
        let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentsDirectory: AnyObject = dir[0]
        
        var path = documentsDirectory.stringByAppendingPathComponent("CompletedData/\(fileName)")
        println("current path = \(path)")
        
        let filemgr = NSFileManager.defaultManager()
        var error: NSError?
        
        if filemgr.removeItemAtPath(path, error: &error) {
            println("\(path) = dir Remove successful")
        } else {
            println("Remove failed: \(error!.localizedDescription)")
        }
        return
    }
    
    
    func releaseMemory() {
        var counter = 0
        for i in 0..<10 {
            autoreleasepool {
                if i == 5 {
                    return
                }
                counter++
            }
        }
    }
    
}
