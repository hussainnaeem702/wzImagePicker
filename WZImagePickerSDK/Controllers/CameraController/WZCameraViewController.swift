//
//  WZCameraViewController.swift
//  WZImagePickerSDK
//
//  Created by Adeel on 27/03/2020.
//  Copyright © 2020 Adeel. All rights reserved.
//

import UIKit
import AVFoundation

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
        
        //           self.navigationController?.navigationBar.topItem?.title = "Camera"
        //           navigationController?.navigationBar.barTintColor        = UIColor(red: 41/255, green: 40/255, blue: 56/255, alpha: 1)
        //           navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)]
        //           tabBarController?.tabBar.barTintColor                   = UIColor(red: 41/255, green: 40/255, blue: 56/255, alpha: 1)
        
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
    // MARK: -  ------------------------ Custom Methods -----------------------------
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
                self.videoPreviewLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)//self.cameraView.bounds
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
    // MARK: -  ------------------------ Actions -----------------------------
    /**************************************************************************************/
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        //        captureImageView.image = image
        print(image)
    }

}
