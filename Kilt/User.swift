//
//  User.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/2/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct User {
    
    static var ref: FIRDatabaseReference? {
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return nil }
        return FIRDatabase.database().reference().child("users/\(currentUserId)")
    }
    
    static func saveName(name: String?) {
        ref?.child("name").setValue(name)
    }
    
    static func saveAddress(address: String?) {
        ref?.child("address").setValue(address)
    }
    
    static func saveIcon(icon: String?) {
        ref?.child("icon").setValue(icon)
    }
    
}
