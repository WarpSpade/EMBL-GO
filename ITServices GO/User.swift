//
//  User.swift
//  ITServices GO
//
//  Created by Thomas Hunt on 26/05/2017.
//  Copyright © 2017 EMBL. All rights reserved.
//

import UIKit
import os.log

class User: NSObject, NSCoding {
    
    var user_name: String
    var email: String
    var start_time: Int
    
    //MARK: Properties
    
    struct PropertyKey {
        static let user_name = "username"
        static let start_time = "start_time"
        static let email = "email"
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("User")
    
    init?(user_name: String, start_time: Int, email: String) {
        guard !user_name.isEmpty else {
            return nil
        }
        self.user_name = user_name
        self.start_time = start_time
        self.email = email
    }
    
    func getName() -> String {
        return self.user_name
    }
    
    func getStart() -> Int {
        return self.start_time
    }
    
    func setEmail(email: String) {
        self.email = email
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user_name, forKey: PropertyKey.user_name)
        aCoder.encode(start_time, forKey: PropertyKey.start_time)
        aCoder.encode(email, forKey: PropertyKey.email)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.user_name) as? String
            else {
                os_log("Unable to decode the name for a User object.", log: OSLog.default,
                       type: .debug)
                return nil
        }
        let email = aDecoder.decodeObject(forKey: PropertyKey.email) as? String
        let start_time = aDecoder.decodeInteger(forKey: PropertyKey.start_time)
        
        if email == nil {
            return nil
        } else {
            self.init(user_name: name, start_time: start_time, email: email!)
        }
        
        
    }
}
