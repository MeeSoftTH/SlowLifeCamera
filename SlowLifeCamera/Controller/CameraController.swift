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
    func updateLabelCamera(text: String)
}

class CameraController: UIViewController, CLLocationManagerDelegate  {
    
    let userSetting: NSUserDefaults! = NSUserDefaults(suiteName: "group.brainexecise")
    let locationManager = CLLocationManager()
    
    var delegate: updateLabel? = nil
    
    @IBOutlet weak var previewView: UIView!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var cameratype: Bool = true
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet var topBar: UIView!
    @IBOutlet var foolbal: UIView!
    
    var locationText = String()
    var timer: NSTimer!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if save.variable.rowSlected == true {
            numberLabel.text = String(save.variable.myNum)
        }
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
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            self.locationText = ("\(locality), \(administrativeArea), \(country)")
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
                
                self.view.addSubview(self.topBar)
                self.view.addSubview(self.foolbal)
                
                captureSession!.startRunning()
                previewLayer!.frame = previewView.bounds
            }
        }
        
    }
    
    @IBAction func shotPress(sender: UIButton) {
        if save.variable.myNum > 0 && save.variable.rowSlected == true{
            if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
                videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
                stillImageOutput!.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                    if (sampleBuffer != nil) {
                        var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                        var dataProvider = CGDataProviderCreateWithCFData(imageData)
                        var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                        
                        var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                        if (image != nil) {
                            self.previewLayer?.removeFromSuperlayer()
                            var format = NSDateFormatter()
                            format.dateFormat="yyyy-MM-dd-HH-mm-ss"
                            var currentFileName: String = "\(format.stringFromDate(NSDate())) + \(self.locationText).jpg"
                            println(currentFileName)
                            
                            let filmRow: AnyObject? = self.userSetting?.objectForKey(save.variable.key)
                            println("Key = \(save.variable.key)")
                            println("path name = \(filmRow)")
                            var filmDir = filmRow!.objectAtIndex(0) as! String
                            
                            initial().createSubAndFileDirectory("RawData", subDir: filmDir, file: currentFileName, image: image!)
                            
                            
                            if save.variable.myNum > 0 {
                                save.variable.myNum = save.variable.myNum - 1
                                self.numberLabel.text = String(save.variable.myNum)
                            }
                            
                            self.captureSession!.stopRunning()
                            self.reloadCamera()
                            self.delegate?.updateLabelCamera(String(save.variable.myNum))
                        }
                    }
                })
            }
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
            self.delegate?.updateLabelCamera(String(save.variable.myNum))
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
