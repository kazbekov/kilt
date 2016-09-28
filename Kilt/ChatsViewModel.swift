//
//  ChatsViewModel.swift
//  Kilt
//
//  Created by Otel Danagul on 06.09.16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseDatabase

final class ChatsViewModel {
    var chats = [Chat]() {
        didSet {
            noDataLabel.hidden = true
            messageIconImageView.hidden = true
        }
    }
    var adminKey = ""
    var noDataLabel: UILabel = UILabel()
    var messageIconImageView: UIImageView = UIImageView()
    func fetchChats(completion: () -> Void) {
        Chat.fetchChats({
            completion()
        }) { (chat) in
            self.chats.append(chat)
            
            chat.ref?.child("/admins/").observeEventType(.ChildAdded) {(snapshot: FIRDataSnapshot!) in FIRDatabase.database().reference().child("users/\(snapshot.key)").observeEventType(.Value, withBlock: { snapshot in
                self.adminKey = snapshot.key
                
                chat.ref?.child("/messages/").observeEventType(.Value) {
                    snapshot in
                    self.fetchLastMessage(snapshot, chat1: chat, completion: completion)
                }
            })
            }
        }
    }
    
    func fetchLastMessage(snapshot: FIRDataSnapshot, chat1: Chat, completion: () -> Void) {
        
        if let lastMessageKey = (snapshot.value as? [String: AnyObject])?.keys.maxElement() {
            FIRDatabase.database().reference().child("messages/\(lastMessageKey)").observeEventType(.Value, withBlock: { snapshot in
                if let lastMessageText = snapshot.value?["text"] as? String, senderName = snapshot.value?["senderName"] as? String, senderId = snapshot.value?["senderId"] as? String {
                    chat1.lastMessage = lastMessageText
                    chat1.senderId = senderId
                    chat1.senderName = senderName
                    chat1.adminId = self.adminKey
                    completion()
                }
            })
            
        }
    }
    
    
}
