//
//  WZCameraViewController.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 27/03/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol WzCaptureImageCameraDelegate {
    func didFinishCapturePicture(_ mediaAssest : [PHAsset]?, _ images : [UIImage]?)
    func didCancelCaptures()
}

class WZCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    /**************************************************************************************/
    // MARK: -  ------------------------ Outlets -----------------------------
    /**************************************************************************************/
    
    @IBOutlet weak var cameraView           : UIView!
    @IBOutlet weak var captureButtonView    : UIView!
    @IBOutlet weak var capturButton         : UIButton!
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Declarations -----------------------------
    /**************************************************************************************/
    
    var captureSession      : AVCaptureSession!
    var stillImageOutput    : AVCapturePhotoOutput!
    var videoPreviewLayer   : AVCaptureVideoPreviewLayer!
    var delegate            : WzCaptureImageCameraDelegate?
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Controlle's Life Cycle -----------------------------
    /**************************************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        capturButton.layer.cornerRadius = capturButton.frame.size.height / 2
        captureButtonView.layer.cornerRadius = captureButtonView.frame.size.height / 2
    }
    
    /**************************************************************************************/
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            //Step 9
            
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
            
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    /**************************************************************************************/
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.captureSession.stopRunning()
    }
    
    /**************************************************************************************/
    // MARK: -  ------------------------ CustomMethods -----------------------------
    /**************************************************************************************/
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(videoPreviewLayer)
        
        //Step12
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
            
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.cameraView.bounds//CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)//
            }
            
        }
        cameraView.addSubview(captureButtonView)
    }
    
    /**************************************************************************************/
    // MARK: -  ------------------------ Actions -----------------------------
    /**************************************************************************************/
       
    @IBAction func captureButtonTapped(_ sender : UIButton)
    {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
       
    /**************************************************************************************/
    // MARK: -  ------------------------ AVCapturePhotoCaptureDelegate -----------------------------
    /**************************************************************************************/
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        if let image = UIImage(data: imageData)
        {
            //        captureImageView.image = image
            print(image)
            
            delegate?.didFinishCapturePicture(nil, [image])
        }
    }

}
