//
//  Chat.swift
//  Kilt
//
//  Created by Otel Danagul on 06.09.16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseDatabase

final class Chat {
    static var ref = FIRDatabase.database().reference().child("chats")
    
    
    var company: Company?
    var ref: FIRDatabaseReference?
    
    init(company: Company) {
        self.company = company
        ref = FIRDatabase.database().reference().child("chats").childByAutoId()
    }
    
    init(snapshot: FIRDataSnapshot, childChanged: () -> Void, completion: (chat: Chat) -> Void) {
        // TODO: make childChanged closure as variable!!!
        snapshot.ref.observeEventType(.Value) { snapshot in
            self.updateFromSnapshot(snapshot)
        }
        if let companyKey = snapshot.value?.objectForKey("company") as? String {
            Company.fetchCompany(companyKey, childChanged: childChanged) { company in
                self.company = company
                completion(chat: self)
            }
        }
    
    
}
    func updateFromSnapshot(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
    }
    
    func saveCompany(completion: (error: NSError?) -> Void) {
        ref?.child("company").setValue(company?.ref?.key) { error, ref in
            completion(error: error)
        }
    }
    
    func addMessage(key: String, completion: (error: NSError?) -> Void){
        ref?.child("messages/\(key)").setValue(true) { error, ref in
            completion(error: error)
            
        }
    }
    
    func addUser(key: String, completion: (error: NSError?) -> Void){
        ref?.child("users/\(key)").setValue(true) { error, ref in
            completion(error: error)
            
        }
    }
    
    func addAdmin(key: String, completion: (error: NSError?) -> Void){
        ref?.child("admins/\(key)").setValue(true) { error, ref in
            completion(error: error)
            
        }
    }
    
    static func fetchChat(key: String, childChanged: () -> Void, completion: (chat: Chat) -> Void) {
        ref.child(key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let _ = Chat(snapshot: snapshot, childChanged: childChanged) { chat in
                completion(chat: chat)
            }
        })
    }
    
    static func fetchChats(childChanged: () -> Void, completion: (chat: Chat) -> Void) {
        User.fetchChats { (snapshot) in
            fetchChat(snapshot.key, childChanged: childChanged) { chat in
                completion(chat: chat)
            }
        }
    }
    
}
