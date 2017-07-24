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
import SceneKit
import CoreLocation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var messagelabel: UILabel!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var mon = [Mon]()
    var monID: String?
    var hasBeenFound = false
    var user: User?
    
    // AR
    //var locationManager = CLLocationManager()
    //var heading: Double = 0
    //var userLocation = CLLocation()
    
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let targetNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
            
            // AR
            //self.locationManager.delegate = self
            //2
            //self.locationManager.startUpdatingHeading()
            
            //sceneView.scene = scene
            //cameraNode.camera = SCNCamera()
            //cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
            //scene.rootNode.addChildNode(cameraNode)
            
        
        } catch {
            // If any error occurs, simply print it out and don't continue any more
            print(error)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let savedMon = loadMon() {
            mon = savedMon
        }
        
        self.user = loadUser()
        
        hasBeenFound = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let monDetailViewController = segue.destination as? MonViewController
            else {
                fatalError("Unexpected sender: \(String(describing: sender))")
        }
        let previousCaught = self.getCaught()
        print(previousCaught)
        // Save that the mon was found
        foundMonWith(Id: monID!)
        let currentCaught = self.getCaught()
        print(currentCaught)
        if (previousCaught == (mon.count - 1) && currentCaught == (mon.count)) {
            let end_time = Date()
            user?.setEndTime(date: end_time)
            saveUser()
            sendEndTimeToDatabase()
            print("finished")
        }
        let selectedMon = getMonWith(Id: monID!)
        monDetailViewController.mon = selectedMon
        monDetailViewController.just_found = true        
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
                if (getMonWith( Id: metadataObj.stringValue ) != nil) {
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
    
    private func getCaught() -> Int {
        var caught = 0
        if mon.count > 0 {
            for monster in mon {
                if monster.isFound() {
                    caught += 1
                }
            }
        }
        return caught
    }

    private func foundMonWith(Id: String){
        let monster = getMonWith(Id: Id)!
        
        monster.setFound(found: true)
        saveMon()
        
        sendCaughtToDatabase()
    }
    
    private func saveMon() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mon, toFile: Mon.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Mon successfully saved.", log: OSLog.default, type: .error)
        } else {
            os_log("Failed to save mon...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadUser() -> User {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User)!
    }
    
    func saveUser() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user!, toFile: User.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("User successfully saved.", log: OSLog.default, type: .error)
        } else {
            os_log("Failed to save user...", log: OSLog.default, type: .error)
        }
    }
    
    private func sendCaughtToDatabase() {
        var request = URLRequest(url: URL(string: "https://labday01.embl.de/updateCaught.php")!)
        request.httpMethod = "POST"
        let postString = "name=\((user?.getName())!)&caught=\(getCaught())"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {          // check for fundamental networking error
                print("\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
        }
        task.resume()
    }
    
    private func sendEndTimeToDatabase() {
        var request = URLRequest(url: URL(string: "https://labday01.embl.de/finish.php")!)
        request.httpMethod = "POST"
        
        let end_time = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let end = dateFormatter.string(from: end_time)
        
        let postString = "name=\((user?.getName())!)&end_time=\(end)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {          // check for fundamental networking error
                print("\(String(describing: error))")
                self.sendEndTimeToDatabase()
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                self.sendEndTimeToDatabase()
            }
        }
        task.resume()
    }
    
}
