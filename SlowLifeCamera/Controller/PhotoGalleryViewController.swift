//
//  ViewController.swift
//  Photos Gallery App
//
//  Created by Tony on 7/7/14.
//  Copyright (c) 2014 Abbouds Corner. All rights reserved.
//
//  Updated to Xcode 6.0.1 GM

import UIKit

class PhotoGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var keySlot = ""
    var filterImage = [String]()
    
    @IBOutlet var slotTitle: UINavigationItem!
    @IBOutlet var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(String(keySlot))
        
        slotTitle.title = self.keySlot
        
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        var fileList = listFilesFromDocumentsFolder()
        
        let count = fileList.count
        
        if count > 0 {
            self.filterImage = fileList
        }
    }
    
    func listFilesFromDocumentsFolder() -> [String]
    {
        var theError = NSErrorPointer()
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if dirs != nil {
            let dir = dirs![0]
            let fileList = NSFileManager.defaultManager().contentsOfDirectoryAtPath("\(dir)/CompletedData/\(self.keySlot)", error: theError)
            return fileList as! [String]
        }else{
            let fileList = [""]
            return fileList
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView:
        UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return self.filterImage.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) ->
        UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell",
                forIndexPath: indexPath) as! PhotoThumbnail
            
            // Configure the cell
            println("shot path Image = \(self.filterImage[indexPath.row])")
            let shotPath = self.filterImage[indexPath.row]
            
            var theError = NSErrorPointer()
            let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
            if dirs != nil {
                let dir = dirs![0]
                let fullPath = "\(dir)/CompletedData/\(self.keySlot)/\(self.filterImage[indexPath.row])"
                
                println("full path Image = \(fullPath)")
                
                let image = UIImage(contentsOfFile: fullPath)
                
                if image != nil {
                    cell.setThumbnailImage(image!)
                }
                
            }
            
            return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller:ViewPhoto = (segue.destinationViewController as? ViewPhoto)!
            if let cell = sender as? UICollectionViewCell{
                    if let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell){
                        controller.index = indexPath.item
                        controller.filterImage = self.filterImage
                        controller.keySlot = self.keySlot
                        controller.filterImage = self.filterImage
                    }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

