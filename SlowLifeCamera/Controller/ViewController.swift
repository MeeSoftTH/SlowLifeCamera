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

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate  {
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var stillImageOutput = AVCaptureStillImageOutput()
    var imageData: NSData!
    var shotImage: UIImage!
    var cameratype: Bool = true
    
    @IBOutlet weak var topbar: UIView!
    @IBOutlet weak var foolBar: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var shotButton: UIButton!
    @IBOutlet weak var capture: UIView!
    @IBOutlet weak var controlView: UIView!
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func shotPress(sender: UIButton) {
        if save.variable.myNum > 0 {
            takePhoto()
        }else {
            let alertController = UIAlertController(title: "Alert", message:
                "This film is have no photo!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func flashEnable(sender: UIButton) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                device.torchMode = AVCaptureTorchMode.Off
                flashButton.tintColor = UIColor.blackColor()
            } else {
                device.setTorchModeOnWithLevel(1.0, error: nil)
                flashButton.tintColor = UIColor.whiteColor()
            }
            device.unlockForConfiguration()
        }
    }
    
    @IBAction func switchCamera(sender: UIButton) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScreen()
        
        numberLabel.text = String(save.variable.myNum) + ("/10")
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
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
                var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
              
                
                //Save the captured preview to image
                if (image != nil) {
                    var format = NSDateFormatter()
                    format.dateFormat="yyyy-MM-dd-HH-mm-ss"
                    var currentFileName = "img-\(format.stringFromDate(NSDate()))"
                    var imageName = currentFileName + ".png"

                    println(imageName)
                    var fileName:String = imageName
                    var arrayPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
                    var pngFileName = arrayPaths.stringByAppendingPathComponent(fileName)
                    UIImagePNGRepresentation(image).writeToFile(pngFileName, atomically:true)
                     println(arrayPaths)
                }
            })
        }
        
        println(save.variable.myNum)
        
        if save.variable.myNum > 0 {
            save.variable.myNum = save.variable.myNum - 1
            numberLabel.text = String(save.variable.myNum) + ("/10")
        }
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateScreen"), userInfo: nil, repeats: true)
        
    }
    
    func updateScreen() {
        controlView.alpha = 1.0
        capture.alpha = 0.0
        shotButton.enabled = true
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
        
        updateDeviceSettings(1.0, isoValue: 1.0)
        
        var err : NSError? = nil
        
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer!.frame = self.view.frame
        
        var bounds:CGRect = self.view.layer.bounds
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer!.bounds = bounds
        previewLayer!.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        
        self.view.layer.addSublayer(previewLayer)
        
        self.view.bringSubviewToFront(numberLabel)
        self.view.bringSubviewToFront(flashButton)
        self.view.bringSubviewToFront(switchCameraButton)
        self.view.bringSubviewToFront(settingButton)
        self.view.bringSubviewToFront(shopButton)
        self.view.bringSubviewToFront(shotButton)
        self.view.bringSubviewToFront(topbar)
        self.view.bringSubviewToFront(foolBar)
        
        previewLayer?.frame = self.view.layer.frame
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
