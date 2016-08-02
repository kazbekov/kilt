//
//  Company.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/2/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Contact {
    var icon: String?
    var name: String?
    var phone: String?
}

struct Company {
    
    let ref = FIRDatabase.database().reference().child("companies")
    
    var name: String?
    var icon: String?
    var contact: [String : AnyObject]?
    
    init(name: String?, icon: String?, contact: Contact? = nil) {
        self.name = name
        self.icon = icon
        self.contact = [
            "icon": contact?.icon ?? NSNull(),
            "name": contact?.name ?? NSNull(),
            "phone": contact?.phone ?? NSNull()
        ]
    }
    
    var dictionaryValue: [String : AnyObject] {
        return [
            "name": name ?? NSNull(),
            "icon": icon ?? NSNull(),
            "contact": contact ?? NSNull()
        ]
    }
    
    func save() {
        ref.updateChildValues([ref.childByAutoId().key : dictionaryValue]) { (error, ref) in
            print("\(error?.localizedDescription)")
        }
    }
    
}
