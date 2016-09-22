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

final  class AddChatViewModel {
    
    let viewModel = ChatsViewModel()
    var chats = [Chat]()
    func createChat(request: Request,completion: (errorMessage: String?) -> Void){
        guard let userKey = FIRAuth.auth()?.currentUser?.uid, let adminKey = request.uid else {
            completion(errorMessage: nil)
            return
        }
        
        let chat = Chat(request: request )
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
        // function adding adminkEY like User.addChat
        chat.addAdmin(adminKey){
            completion(errorMessage: $0?.localizedDescription)
        }
        
        let ref = FIRDatabase.database().reference().child("users")
        ref.child("\(adminKey)/chats/\(chatKey)").setValue(true)

    }
    func addMessage(chat: Chat, messageKey: String?,completion: (errorMessage: String?) -> Void){
        chat.addMessage(messageKey!) {
            completion(errorMessage: $0?.localizedDescription)
        }
        
    }
}
