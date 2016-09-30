//
//  Chat.swift
//  Kilt
//
//  Created by Otel Danagul on 06.09.16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

final class Chat {
    static var ref = FIRDatabase.database().reference().child("chats")
    

    var request: Request?
    var ref: FIRDatabaseReference?
    
    var lastMessage: String?
    var senderId: String?
    var senderName: String?
    var adminId: String?
    var adminName: String?
    
    init(request: Request) {
        self.request = request
        ref = FIRDatabase.database().reference().child("chats").childByAutoId()
    }
    
    init(key: String, snapshot: FIRDataSnapshot, childChanged: () -> Void, completion: (chat: Chat) -> Void) {
        snapshot.ref.observeEventType(.Value) { snapshot in
            self.updateFromSnapshot(snapshot)
        }
        if let companyKey = snapshot.value?.objectForKey("request") as? String {
            Request.fetchRequest(companyKey, childChanged: childChanged) { request in
                self.request = request
                self.adminId = request.uid
                self.adminName = request.companyName
                completion(chat: self)
            }
        }
        
//        senderId = snapshot.value?.objectForKey("users") as? String
        if let senderId = senderId {
            User.fetchCurrentUserName(senderId) { name in
                self.senderName = name
            }
        }
    }
    
    func fetchUserIds(completion: ([String]) -> Void) {
        ref?.child("users").observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard let dictionary = snapshot.value as? [String: Bool] else {return}
            completion(Array(dictionary.keys))
        })
    }
    
    func fetchAdminIds(completion: ([String]) -> Void) {
        ref?.child("admins").observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard let dictionary = snapshot.value as? [String: Bool] else {return}
            completion(Array(dictionary.keys))
        
        })
    }

    func updateFromSnapshot(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
    }
    
    func saveCompany(completion: (error: NSError?) -> Void) {
        ref?.child("request").setValue(request?.ref?.key) { error, ref in
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
            let _ = Chat(key: key, snapshot: snapshot, childChanged: childChanged) { chat in
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
