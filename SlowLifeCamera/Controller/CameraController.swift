//
//  ViewController.swift
//  SlowLifeCamera
//
//  Created by Pawarit_Bunrith on 7/2/2558 BE.
//  Copyright (c) 2558 Pawarit_Bunrith. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Foundation

class CameraController: UIViewController, UIPopoverPresentationControllerDelegate  {
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var stillImageOutput = AVCaptureStillImageOutput()
    var imageData: NSData!
    var shotImage: UIImage!
    var cameratype: Bool = true
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var shotButton: UIButton!
    @IBOutlet weak var capture: UIView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var flashView: UIButton!
    
    var timer: NSTimer!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScreen()
        
        
        if save.variable.rowSlected == true {
            numberLabel.text = String(save.variable.myNum) + (" of 25")
        }
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        beginSession()
                        updateDeviceSettings(1.0, isoValue: 1.0)
                    }
                }
            }
        }
    }
    
    @IBAction func shotPress(sender: UIButton) {
        if save.variable.myNum > 0 && save.variable.rowSlected == true{
            takePhoto()
        }else if save.variable.myNum == 0 && save.variable.rowSlected == true{
            let alertController = UIAlertController(title: "", message:
                "This film is have no photo!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else if save.variable.rowSlected == false {
            let alertController = UIAlertController(title: "", message:
                "Select film frist", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func flashEnable(sender: UIButton) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                device.torchMode = AVCaptureTorchMode.Off
                flashButton.setImage(UIImage(named: "flashOff" as String), forState: UIControlState.Normal)
                
            } else {
                device.setTorchModeOnWithLevel(1.0, error: nil)
                flashButton.setImage(UIImage(named: "flashOn" as String), forState: UIControlState.Normal)
            }
            device.unlockForConfiguration()
        }
    }
    
    @IBAction func switchCamera(sender: UIButton) {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        for oldInput : AnyObject in captureSession.inputs {
            if let captureInput = oldInput as? AVCaptureInput {
                captureSession.removeInput(captureInput)
            }
        }
        captureSession.stopRunning()
        if(cameratype == true) {
            let devices = AVCaptureDevice.devices()
            for device in devices {
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    if(device.position == AVCaptureDevicePosition.Front) {
                        captureDevice = device as? AVCaptureDevice
                        if captureDevice != nil {
                            beginSession()
                            cameratype = false
                        }
                    }
                }
            }
        } else {
            let devices = AVCaptureDevice.devices()
            for device in devices {
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    if(device.position == AVCaptureDevicePosition.Back) {
                        captureDevice = device as? AVCaptureDevice
                        if captureDevice != nil {
                            beginSession()
                            cameratype = true
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func myBag(sender: UIButton) {
        if save.variable.myNum >= 0 && save.variable.myNum < 26 && save.variable.key != ""{
            
            let path: AnyObject? = self.userSetting?.objectForKey(save.variable.key)
            
            let slotName = path!.objectAtIndex(0) as! String
            let filterCode = path!.objectAtIndex(1) as! String
            let filterName = path!.objectAtIndex(2) as! String
            var num = path!.objectAtIndex(3) as! Int
            let isOn = path!.objectAtIndex(4) as! Bool
            
            num = save.variable.myNum
            numberLabel.text = ""
            
            self.userSetting?.setObject([slotName, filterCode, filterName, num, isOn], forKey: save.variable.key)
        }
    }
    
    func takePhoto() {
        shotButton.enabled = false
        controlView.alpha = 0.0
        capture.alpha = 1.0
        
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        
        var videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        
        if videoConnection != nil {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                (sampleBuffer, error) in
                var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                var dataProvider = CGDataProviderCreateWithCFData(imageData)
                var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                var imageUI = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                
                
                //Save the captured preview to image
                if (imageUI != nil) {
                    
                    var format = NSDateFormatter()
                    format.dateFormat="yyyy-MM-dd-HH-mm-ss"
                    var currentFileName: String = "img-\(format.stringFromDate(NSDate())).jpg"
                    println(currentFileName)
                    
                    let filmRow: AnyObject? = self.userSetting?.objectForKey(save.variable.key)
                    println("Key = \(save.variable.key)")
                    println("path name = \(filmRow)")
                    var filmDir = filmRow!.objectAtIndex(0) as! String
                    
                    initial().createSubAndFileDirectory("RawData", subDir: filmDir, file: currentFileName, image: imageUI!)
                }
            })
            
        }
        
        if save.variable.myNum > 0 {
            save.variable.myNum = save.variable.myNum - 1
            numberLabel.text = String(save.variable.myNum) + (" of 25")
        }
        
        delay(1){
            self.updateScreen()
        }
    }
    
    func updateScreen() {
        controlView.alpha = 1.0
        capture.alpha = 0.0
        shotButton.enabled = true
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    
    func updateDeviceSettings(focusValue : Float, isoValue : Float) {
        if let device = captureDevice {
            if(device.lockForConfiguration(nil)) {
                device.focusMode = AVCaptureFocusMode.ContinuousAutoFocus
                device.unlockForConfiguration()
            }
        }
    }
    
    func beginSession() {
        
        //updateDeviceSettings(1.0, isoValue: 1.0)
        
        var err : NSError? = nil
        
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        
        self.view.layer.addSublayer(previewLayer)
        self.view.bringSubviewToFront(self.numberLabel)
        self.view.bringSubviewToFront(self.flashButton)
        self.view.bringSubviewToFront(self.switchCameraButton)
        self.view.bringSubviewToFront(self.settingButton)
        self.view.bringSubviewToFront(self.shotButton)
        
        self.previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
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
