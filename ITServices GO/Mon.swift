//
//  Mon.swift
//  ITServices GO
//
//  Created by Thomas Hunt on 15/05/17.
//  Copyright © 2017 EMBL. All rights reserved.
//

import UIKit
import os.log

class Mon: NSObject, NSCoding {
    
    var id: String
    var found: Bool
    var name: String
    var not_found_image: UIImage?
    var found_image: UIImage?
    var fact: String
    
    //MARK: Properties
    
    struct PropertyKey {
        static let name = "name"
        static let id = "id"
        static let not_found_image = "not_found_image"
        static let found_image = "found_image"
        static let fact = "fact"
        static let found = "found"
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Mon")
    
    init?(name: String, not_found: UIImage?, found: UIImage?, fact: String, id: String, is_found: Bool) {
        guard !name.isEmpty else {
            return nil
        }
        self.id = id
        self.name = name
        self.not_found_image = not_found
        self.found_image = found
        self.fact = fact
        self.found = is_found
    }
    
    func isFound() -> Bool {
        return self.found
    }
    
    func getId() -> String {
        return self.id
    }
    
    func setFound(found: Bool) {
        self.found = found
    }
    
    func getFoundImage() -> UIImage? {
        return self.found_image
    }
    
    func getNotFoundImage() -> UIImage? {
        return self.not_found_image
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getFact() -> String {
        return self.fact
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(not_found_image, forKey: PropertyKey.not_found_image)
        aCoder.encode(found_image, forKey: PropertyKey.found_image)
        aCoder.encode(fact, forKey: PropertyKey.fact)
        aCoder.encode(found, forKey: PropertyKey.found)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
                os_log("Unable to decode the name for a Meal object.", log: OSLog.default,
                       type: .debug)
                return nil
        }
        let id = aDecoder.decodeObject(forKey: PropertyKey.id) as? String
        let not_found_image = aDecoder.decodeObject(forKey: PropertyKey.not_found_image) as? UIImage
        let found_image = aDecoder.decodeObject(forKey: PropertyKey.found_image) as? UIImage
        let fact = aDecoder.decodeObject(forKey: PropertyKey.fact) as? String
        let found = aDecoder.decodeBool(forKey: PropertyKey.found)
        
        if id == nil {
            return nil
        } else {
            self.init(name: name, not_found: not_found_image!, found: found_image!, fact: fact!, id: id!, is_found: found)
        }
            
        
    }
}

