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
    
    static func saveName(name: String?, completion: (error: NSError?) -> Void) {
        ref?.child("name").setValue(name) { error, ref in
            completion(error: error)
        }
    }
    
    static func saveAddress(address: String?, completion: (error: NSError?) -> Void) {
        ref?.child("address").setValue(address) { error, ref in
            completion(error: error)
        }
    }
    
    static func saveIcon(icon: String?, completion: (error: NSError?) -> Void) {
        ref?.child("icon").setValue(icon) { error, ref in
            completion(error: error)
        }
    }
    
    static func addCard(key: String, completion: (error: NSError?) -> Void) {
        ref?.child("cards/\(key)").setValue(true) { error, ref in
            completion(error: error)
        }
    }
    
    static func addChat(key: String, completion: (error: NSError?) -> Void) {
        ref?.child("chats/\(key)").setValue(true) { error, ref in
            completion(error: error)
            
        }
    }

    static func fetchIsVerified(completion: (Bool?) -> Void) {
        ref?.observeEventType(.Value, withBlock: { (snapshot) in
            completion(snapshot.value?["isVerified"] as? Bool)
        })

    }

    static func fetchName(completion: (String?) -> Void) {
        ref?.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            completion(snapshot.value?["name"] as? String)
        })
    }
    
    static func fetchAddress(completion: (String?) -> Void) {
        ref?.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            completion(snapshot.value?["address"] as? String)
        })
    }
    
    static func fetchIcon(completion: (String?) -> Void) {
        ref?.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            completion(snapshot.value?["icon"] as? String)
        })
    }
    
    
    static func fetchCards(completion: (snapshot: FIRDataSnapshot) -> Void) {
        ref?.child("cards").observeEventType(.ChildAdded) { snapshot in
            completion(snapshot: snapshot)
        }
}
    
    static func fetchChats(completion: (snapshot: FIRDataSnapshot) -> Void) {
        ref?.child("chats").observeEventType(.ChildAdded) {
            snapshot in
            completion(snapshot: snapshot)
        }
    }
}
