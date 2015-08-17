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
import CoreLocation

protocol updateLabel {
    func updateLabelCamera(text: String, isDev: Bool)
}

class CameraController: UIViewController, CLLocationManagerDelegate  {
    
    let userSetting: NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    let locationManager = CLLocationManager()
    
    var delegate: updateLabel? = nil
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet var captureView: UIView!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var cameratype: Bool = true
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet var shotButton: UIButton!
    @IBOutlet var topBar: UIView!
    @IBOutlet var foolbal: UIView!
    
    var locationText = String()
    var timer: NSTimer!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataSetting.variable.rowSlected == true {
            numberLabel.text = "Service's starting..."
        }
        
        self.shotButton.enabled = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        reloadCamera()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            self.locationText = ("\(administrativeArea),\(country)")
            
            println("Location on, Ready to take photos")
            
            if DataSetting.variable.rowSlected == true {
                
                numberLabel.text = "Service's ready!"
                self.shotButton.enabled = true
                
                delay(2.0) {
                    self.numberLabel.text = String(DataSetting.variable.myNum)
                    
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    
    func reloadCamera() {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        var error: NSError?
        var input = AVCaptureDeviceInput(device: captureDevice, error: &error)
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                previewView.layer.addSublayer(previewLayer)
                
                self.view.addSubview(self.captureView)
                self.view.addSubview(self.topBar)
                self.view.addSubview(self.foolbal)
                
                captureSession!.startRunning()
                previewLayer!.frame = previewView.bounds
            }
        }
        
    }
    
    @IBAction func shotPress(sender: UIButton) {
        if DataSetting.variable.myNum > 0 && DataSetting.variable.rowSlected == true {
            
            self.captureView.alpha = 1.0
            self.previewView.alpha = 0.0
            self.shotButton.enabled = false
            
            if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
                var newOrientation : AVCaptureVideoOrientation
                var imgOrientation : UIImageOrientation
                let deviceOrientation = UIDevice.currentDevice().orientation
                switch(deviceOrientation)
                {
                case UIDeviceOrientation.Portrait:
                    newOrientation = AVCaptureVideoOrientation.Portrait
                    imgOrientation = UIImageOrientation.Right
                    break
                case UIDeviceOrientation.PortraitUpsideDown:
                    newOrientation = AVCaptureVideoOrientation.PortraitUpsideDown
                    imgOrientation = UIImageOrientation.Right // .Left
                    break
                case UIDeviceOrientation.LandscapeLeft:
                    newOrientation = AVCaptureVideoOrientation.LandscapeLeft
                    imgOrientation = UIImageOrientation.Up
                    break
                case UIDeviceOrientation.LandscapeRight:
                    newOrientation = AVCaptureVideoOrientation.LandscapeRight
                    imgOrientation = UIImageOrientation.Down
                    break
                default :
                    newOrientation = AVCaptureVideoOrientation.Portrait
                    imgOrientation = UIImageOrientation.Right
                    break
                    
                }
                
                videoConnection.videoOrientation = newOrientation // AVCaptureVideoOrientation.Portrait
                stillImageOutput!.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                    if (sampleBuffer != nil) {
                        var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                        var dataProvider = CGDataProviderCreateWithCFData(imageData)
                        var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                        
                        var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: imgOrientation)
                        //var image = UIImage(CGImage: cgImageRef)
                        if (image != nil) {
                            var format = NSDateFormatter()
                            format.dateFormat="yyyyMMdd_HHmmss"
                            var currentFileName: String = "\(format.stringFromDate(NSDate())),\(self.locationText).jpg"
                            println(currentFileName)
                            
                            let filmRow: AnyObject? = self.userSetting?.objectForKey(DataSetting.variable.key)
                            println("Key = \(DataSetting.variable.key)")
                            println("path name = \(filmRow)")
                            var filmDir = filmRow!.objectAtIndex(0) as! String
                            
                            GlobalFunction().createSubAndFileDirectory("RawData", subDir: filmDir, file: currentFileName, image: image!)
                            
                            
                            if DataSetting.variable.myNum >= 0 {
                                self.numberLabel.text = String(DataSetting.variable.myNum)
                            }
                            
                            if DataSetting.variable.myNum == 0 {
                                
                                let path: AnyObject? = self.userSetting?.objectForKey(DataSetting.variable.key)
                                
                                let slotName = path!.objectAtIndex(0) as! String
                                let filterCode = path!.objectAtIndex(1) as! String
                                let filterName = path!.objectAtIndex(2) as! String
                                var num = path!.objectAtIndex(3) as! Int
                                var filmLength = path!.objectAtIndex(4) as! Int
                                let isOn = path!.objectAtIndex(5) as! Bool
                                
                                num = DataSetting.variable.myNum
                                
                                DataSetting.variable.myNum = 0
                                
                                self.userSetting?.setObject([slotName, filterCode, filterName, num, filmLength, isOn], forKey: DataSetting.variable.key)

                                self.delegate?.updateLabelCamera(String(DataSetting.variable.myNum), isDev: true)
                                self.delay(0.5) {
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                                
                            }
                        }
                        self.captureView.alpha = 0.0
                        self.previewView.alpha = 1.0
                        self.shotButton.enabled = true
                    }
                })
            }
            
        }else if DataSetting.variable.myNum == 0 && DataSetting.variable.rowSlected == true{
            let alertController = UIAlertController(title: "", message:
                "film is have no photo", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close camera", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else if DataSetting.variable.rowSlected == false {
            let alertController = UIAlertController(title: "", message:
                "Select film frist", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
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
        captureSession!.sessionPreset = AVCaptureSessionPresetHigh
        for oldInput : AnyObject in captureSession!.inputs {
            if let captureInput = oldInput as? AVCaptureInput {
                captureSession!.removeInput(captureInput)
            }
        }
        captureSession!.stopRunning()
        previewLayer?.removeFromSuperlayer()
        if(cameratype == true) {
            let devices = AVCaptureDevice.devices()
            for device in devices {
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    if(device.position == AVCaptureDevicePosition.Front) {
                        captureDevice = device as? AVCaptureDevice
                        if captureDevice != nil {
                            reloadCamera()
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
                            reloadCamera()
                            cameratype = true
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func myBag(sender: UIButton) {
        if DataSetting.variable.myNum >= 0 && DataSetting.variable.myNum < 26 && DataSetting.variable.key != "" {
            
            self.delegate?.updateLabelCamera(String(DataSetting.variable.myNum), isDev: false)
            
            let path: AnyObject? = self.userSetting?.objectForKey(DataSetting.variable.key)
            
            let slotName = path!.objectAtIndex(0) as! String
            let filterCode = path!.objectAtIndex(1) as! String
            let filterName = path!.objectAtIndex(2) as! String
            var num = path!.objectAtIndex(3) as! Int
            var filmLength = path!.objectAtIndex(4) as! Int
            let isOn = path!.objectAtIndex(5) as! Bool
            
            num = DataSetting.variable.myNum
            
            self.userSetting?.setObject([slotName, filterCode, filterName, num, filmLength, isOn], forKey: DataSetting.variable.key)
        }
        
        self.delay(0.5) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func updateDeviceSettings(focusValue : Float, isoValue : Float) {
        if let device = captureDevice {
            if(device.lockForConfiguration(nil)) {
                device.focusMode = AVCaptureFocusMode.ContinuousAutoFocus
                device.unlockForConfiguration()
            }
        }
    }
}
