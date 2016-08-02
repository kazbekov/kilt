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
    
    private var ref: FIRDatabaseReference? {
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return nil }
        return FIRDatabase.database().reference().child("users/\(currentUserId)")
    }
    
    var name: String?
    var address: String?
    var icon: String?
    var cards: [String : Bool]?
    
    init(name: String? = nil, address: String? = nil, icon: String? = nil, cards: [String : Bool]? = nil) {
        self.name = name
        self.address = address
        self.icon = icon
        self.cards = cards
    }
    
    func saveName() {
        ref?.child("name").setValue(name)
    }
    
    func saveAddress() {
        ref?.child("address").setValue(address)
    }
    
    func saveIcon() {
        ref?.child("icon").setValue(icon)
    }
    
}
