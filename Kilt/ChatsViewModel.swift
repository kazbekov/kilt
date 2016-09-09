//
//  ChatsViewModel.swift
//  Kilt
//
//  Created by Otel Danagul on 06.09.16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class ChatsViewModel {
    var chats = [Chat]()
    
    func fetchChats(completion: () -> Void) {
        Chat.fetchChats({
            completion()
        }) { (chat) in
            self.chats.append(chat)
            completion()
        }
    }
}
