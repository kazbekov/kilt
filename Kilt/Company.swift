//
//  Company.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/2/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class Contact {
    var icon: String?
    var name: String?
    var phone: String?
}

final class Company {
    
    var ref: FIRDatabaseReference?
    
    var name: String?
    var icon: String?
    var contact: [String : AnyObject]?
    
    init(key: String?, name: String?, icon: String?, contact: Contact? = nil) {
        self.name = name
        self.icon = icon
        self.contact = [
            "icon": contact?.icon ?? NSNull(),
            "name": contact?.name ?? NSNull(),
            "phone": contact?.phone ?? NSNull()
        ]
        if let key = key {
            ref = FIRDatabase.database().reference().child("companies/\(key)")
        } else {
            ref = FIRDatabase.database().reference().child("companies").childByAutoId()
        }
    }
    
    func saveName(completion: (error: NSError?) -> Void) {
        ref?.child("name").setValue(name) { error, ref in
            completion(error: error)
        }
    }
    
    func saveIcon(completion: (error: NSError?) -> Void) {
        ref?.child("icon").setValue(icon) { error, ref in
            completion(error: error)
        }
    }
    
    func saveContact(completion: (error: NSError?) -> Void) {
        ref?.child("contact").setValue(contact) { error, ref in
            completion(error: error)
        }
    }
    
}
