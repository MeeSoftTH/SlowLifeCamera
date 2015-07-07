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

class ViewController: UIViewController  {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var stillImageOutput = AVCaptureStillImageOutput()
    var imageData: NSData!
    var shotImage: UIImage!
    var cameratype: Bool = true
    
    @IBOutlet weak var shotButton: UIButton!
    @IBOutlet weak var shotPicture: UIImageView!
    @IBOutlet weak var leftWing: UIButton!
    @IBOutlet weak var rightWing: UIButton!
    @IBOutlet weak var exButton: UIButton!
    
    @IBAction func shotPress(sender: UIButton) {
        takePicture()
        self.view.bringSubviewToFront(shotPicture)
        self.view.sendSubviewToBack(shotButton)
        self.view.sendSubviewToBack(leftWing)
        self.view.sendSubviewToBack(rightWing)
        self.view.bringSubviewToFront(exButton)
    }
    
    @IBAction func exitPress(sender: UIButton) {
        shotPicture.image = nil
        shotPicture.backgroundColor = UIColor.blackColor()
        self.view.sendSubviewToBack(shotPicture)
        self.view.sendSubviewToBack(exButton)
        self.view.bringSubviewToFront(shotButton)
        self.view.bringSubviewToFront(leftWing)
        self.view.bringSubviewToFront(rightWing)
    }
    
    @IBAction func switchCamera(sender: UIButton) {
        shotPicture.image = nil
        shotPicture.backgroundColor = UIColor.blackColor()
        self.view.sendSubviewToBack(exButton)
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
                    self.shotPicture.image = UIImage(data: AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer))
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
        self.view.layer.addSublayer(previewLayer)
        self.view.bringSubviewToFront(shotButton)
        self.view.bringSubviewToFront(leftWing)
        self.view.bringSubviewToFront(rightWing)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
}
