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
    var start_time: Date
    var end_time: Date?
    
    //MARK: Properties
    
    struct PropertyKey {
        static let user_name = "username"
        static let start_time = "start_time"
        static let end_time = "end_time"
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("User")
    
    init?(user_name: String, start_time: Date, end_time: Date?) {
        guard !user_name.isEmpty else {
            return nil
        }
        self.user_name = user_name
        self.start_time = start_time
        self.end_time = end_time
    }
    
    func getName() -> String {
        return self.user_name
    }
    
    func getStartTimeAsString() -> String {
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: self.start_time)
        let minutes = calendar.component(.minute, from: self.start_time)
        let seconds = calendar.component(.second, from: self.start_time)
        
        return "\(hour):\(minutes):\(seconds)"
    }
    
    func getStartTime() -> Date {
        return start_time
    }
    
    func getEndTime() -> Date? {
        return end_time
    }
    
    func setEndTime(date: Date) {
        self.end_time = date
    }
    
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user_name, forKey: PropertyKey.user_name)
        aCoder.encode(start_time, forKey: PropertyKey.start_time)
        aCoder.encode(end_time, forKey: PropertyKey.end_time)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.user_name) as? String
            else {
                os_log("Unable to decode the name for a User object.", log: OSLog.default,
                       type: .debug)
                return nil
        }
        let start_time = aDecoder.decodeObject(forKey: PropertyKey.start_time) as? Date
        let end_time = aDecoder.decodeObject(forKey: PropertyKey.end_time) as? Date
        
        if start_time == nil {
            return nil
        } else {
            self.init(user_name: name, start_time: start_time!, end_time: end_time)
        }
        
        
    }
}
