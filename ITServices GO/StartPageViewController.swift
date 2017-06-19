//
//  StartPageViewController.swift
//  ITServices GO
//
//  Created by Thomas Hunt on 29/05/2017.
//  Copyright © 2017 EMBL. All rights reserved.
//

import UIKit
import os.log

class StartPageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var message: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StartPageViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        self.textField.delegate = self
        
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func start(_ sender: Any) {
        
        let name = textField.text
        
        let trimmed_name = name?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (name == nil) {
            message.text = "Please enter a valid name before you begin"
        } else if ((trimmed_name?.characters.count)! < 3) {
            message.text = "The name you have entered is too short"
        } else if ((trimmed_name?.characters.count)! > 16) {
            message.text = "The name you have entered is too long"
        } else {
            let date = Date()
            self.user = User(user_name:trimmed_name!, start_time: date, end_time: nil)!
            sendToDatabase(name: (user?.getName())!, start_time: (user?.getStartTimeAsString())!)
        }
    }
    
    func sendToDatabase(name: String, start_time: String) {
        var request = URLRequest(url: URL(string: "https://www.labday01.embl.de/dbconnect.php")!)
        request.httpMethod = "POST"
        let url_name = name.replacingOccurrences(of: " ", with: "+")
        let url_start_time = start_time.replacingOccurrences(of: " ", with: "+")
        let postString = "name=\(url_name)&start_time=\(url_start_time)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {          // check for fundamental networking error
                self.message.text = "error=\(String(describing: error))"
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                self.message.text = "response = \(String(describing: response))"
            } else {
                let responseString = String(data: data, encoding: .utf8)
                if ((responseString?.range(of: "Duplicate")) != nil) {
                    self.message.text = "Name already used, please try another one."
                } else if ((responseString?.range(of: "success")) != nil) {
                    self.saveUser()
                    self.performSegue(withIdentifier: "StartSegue", sender: self)
                }
            }
            
        }
        task.resume()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func saveUser() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user!, toFile: User.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("User successfully saved.", log: OSLog.default, type: .error)
        } else {
            os_log("Failed to save user...", log: OSLog.default, type: .error)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
