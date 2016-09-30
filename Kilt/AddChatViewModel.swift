//
//  AddChatViewModel.swift
//  Kilt
//
//  Created by Otel Danagul on 06.09.16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

final class AddChatViewModel {
    
    let viewModel = ChatsViewModel()
    var chats = [Chat]()
    var exist = false

    func checkIfExist(request: Request, completion: (exist: Bool) -> Void) {
        guard let requestKey = request.ref?.key else { return }
        User.fetchAndCompareRequest(requestKey) { dict in
            if let keys = dict?.keys {
                let arr = Array(keys)
                var counter = 0
                for key in arr {
                    Chat.fetchChatRequest(key) { key in
                        counter += 1
                        if let key = key where requestKey == key {
                            self.exist = true
                        }
                        if arr.count == counter {
                            completion(exist: self.exist)
                        }
                    }
                }
            } else {
                completion(exist: false)
            }
        }
    }

    func createChat(request: Request,completion: (errorMessage: String?) -> Void){
        checkIfExist(request) { exist in
            guard !exist else { return }

            guard let userKey = FIRAuth.auth()?.currentUser?.uid, let adminKey = request.uid else {
                completion(errorMessage: nil)
                return
            }

            let chat = Chat(request: request)
            chat.saveCompany { completion(errorMessage: $0?.localizedDescription) }

            guard let chatKey = chat.ref?.key else {
                completion(errorMessage: nil)
                return
            }
            User.addChat(chatKey) {
                completion(errorMessage: $0?.localizedDescription)
            }
            chat.addUser(userKey){
                completion(errorMessage: $0?.localizedDescription)
            }
            chat.addAdmin(adminKey){
                completion(errorMessage: $0?.localizedDescription)
            }

            let ref = FIRDatabase.database().reference().child("users")
            ref.child("\(adminKey)/chats/\(chatKey)").setValue(true)
        }
    }
    func addMessage(chat: Chat, messageKey: String?,completion: (errorMessage: String?) -> Void){
        chat.addMessage(messageKey!) {
            completion(errorMessage: $0?.localizedDescription)
        }
    }
}
