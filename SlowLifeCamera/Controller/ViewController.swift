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
    
    
    @IBAction func shotPress(sender: UIButton) {
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController!.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        beginSession()
                        takePicture()
                    }
                }
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func takePicture() {
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        var videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        if(cameratype == true) {
            videoConnection.videoMirrored = false
        } else {
            videoConnection.videoMirrored = true
        }
        
        if videoConnection != nil {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(stillImageOutput.connectionWithMediaType(AVMediaTypeVideo))
                { (imageDataSampleBuffer, error) -> Void in
                    
            }}
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
