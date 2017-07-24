//
//  StartPageViewController.swift
//  ITServices GO
//
//  Created by Thomas Hunt on 29/05/2017.
//  Copyright © 2017 EMBL. All rights reserved.
//

import UIKit
import os.log
import ActiveLabel

class StartPageViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var option: UISegmentedControl!
    @IBOutlet weak var instructions: UILabel!
    
    var user: User?
    var guest = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UITextField.connectFields(fields: [textField, password])
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StartPageViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        self.textField.delegate = self
        
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 6
        
        // move view up with keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                let height = keyboardSize.height
                
                self.view.frame.origin.y -= height
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                let height = keyboardSize.height
                self.view.frame.origin.y += height
            }
            
        }
    }
    
    
    @IBAction func optionChanged(_ sender: Any) {
        switch option.selectedSegmentIndex
        {
        case 0:
            instructions.font = UIFont(name: instructions.font.fontName, size: 17)
            instructions.text = "Sign in with your EMBL credentials";
            guest = "false"
        case 1:
            instructions.font = UIFont(name: instructions.font.fontName, size: 17)
            instructions.text = "Choose a username and enter the guest password. \n (Find it in your email or ask at the IT Services Booth)";
            guest = "true"
        default:
            break
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func start(_ sender: Any) {
        
        let name = self.textField.text
        let password = self.password.text
        
        let trimmed_name = name?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (name == "") {
            message.text = "Please enter your Username."
        } else if (password == "") {
            message.text = "Please enter your Password"
        } else {
            let date = Date()
            self.user = User(user_name:trimmed_name!, start_time: date, end_time: nil)!
            sendToDatabase(name: (user?.getName())!, password: password!, start_time: (user?.getStartTime())!)
        }
        dismissKeyboard()
    }
    
    func sendToDatabase(name: String, password: String, start_time: Date) {
        var request = URLRequest(url: URL(string: "https://labday01.embl.de/login.php")!)
        request.httpMethod = "POST"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let start = dateFormatter.string(from: start_time)
        
        let url_name = name.replacingOccurrences(of: " ", with: "+")
        let url_start_time = start.replacingOccurrences(of: " ", with: "+")
        let postString = "name=\(url_name)&start_time=\(url_start_time)&password=\(password)&guest=\(self.guest)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {          // check for fundamental networking error
                //self.message.text = "Network error. Please check your connection."
                self.message.text = "\(String(describing: error))";
                os_log(error as! StaticString);
                //self.HUD?.hide()
                return
            }
            DispatchQueue.main.async {
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("To play the game you must be connected to the Wifi at EMBL")
                    self.message.text = "response = \(String(describing: response))"
                } else {
                    
                    let responseString = String(data: data, encoding: .utf8)
                    if ((responseString?.range(of: "Username or Password is Incorrect")) != nil) {
                        self.message.text = "Your username or password is incorrect, please try again."
                    } else if ((responseString?.range(of: "Password Incorrect")) != nil) {
                        self.message.text = "The guest password you have entered is incorrect, please try again."
                    } else if ((responseString?.range(of: "SuccessDuplicate")) != nil) {
                        self.saveUser()
                        self.performSegue(withIdentifier: "StartSegue", sender: self)
                    } else if ((responseString?.range(of: "Name is taken")) != nil) {
                        self.message.text = "The username you chose in not available, please try another one."
                    } else if ((responseString?.range(of: "Game not started")) != nil) {
                        self.message.text = "The game has not started yet, please try again later."
                    } else if ((responseString?.range(of: "Successsuccess")) != nil) {
                        self.saveUser()
                        self.performSegue(withIdentifier: "StartSegue", sender: self)
                    } else {
                        self.message.text = "Error: \(String(describing: response))"
                        print("Error: \(String(describing: responseString)))")
                    }
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

extension UITextField {
    class func connectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
}



