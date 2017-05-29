//
//  QRViewController.swift
//  ITServices GO
//
//  Created by Thomas Hunt on 12/05/17.
//  Copyright © 2017 EMBL. All rights reserved.
//

import UIKit
import AVFoundation
import os.log

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messagelabel: UILabel!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var mon = [Mon]()
    var monID: String?
    var hasBeenFound = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let savedMon = loadMon() {
            mon += savedMon
        }
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and prov
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device obj
            let input = try AVCaptureDeviceInput(device:captureDevice)
            
            // Initialize the captureSessionobject.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session 
            captureSession?.addInput(input)
            
            // Initialize a AvCaptureMetadataOutput object and set it as the output device to the
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back 
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: messagelabel)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView{
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        
        } catch {
            // If any error occurs, simply print it out and don't continue any more
            print(error)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let monDetailViewController = segue.destination as? MonViewController
            else {
                fatalError("Unexpected sender: \(String(describing: sender))")
        }
        // Save that the mon was found
        foundMonWith(Id: monID!)
        let selectedMon = getMonWith(Id: monID!)
        monDetailViewController.mon = selectedMon
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messagelabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                if (1...(mon.count + 1)) ~= (Int(metadataObj.stringValue)!) {
                    monID = metadataObj.stringValue
                    if hasBeenFound == false {
                        hasBeenFound = true
                        performSegue(withIdentifier: "foundMon", sender: self)
                    }
                } else {
                    self.messagelabel.text = "Not a valid QR"
                }
            }
        }
    }
    
    private func loadMon() -> [Mon]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Mon.ArchiveURL.path) as? [Mon]
    }
    
    private func getMonWith(Id: String) -> Mon?{
        for monster in mon {
            if monster.getId() == Id {
                return monster
            }
        }
        return nil
    }
    
    private func foundMonWith(Id: String){
        let monster = getMonWith(Id: Id)!
        monster.setFound(found: true)
        saveMon()
    }
    
    private func saveMon() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mon, toFile: Mon.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Mon successfully saved.", log: OSLog.default, type: .error)
        } else {
            os_log("Failed to save mon...", log: OSLog.default, type: .error)
        }
    
    
    }
}
