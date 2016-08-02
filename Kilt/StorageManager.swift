//
//  StorageManager.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/2/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

struct StorageManager {
    
    static let ref = FIRStorage.storage().referenceForURL("gs://kilt-b9074.appspot.com")
    
    static func saveAvatar(data: NSData, completion: (url: NSURL?, error: NSError?) -> Void) {
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        ref.child("avatars/\(currentUserId).jpg").putData(data, metadata: nil) { metadata, error in
            completion(url: metadata?.downloadURL(), error: error)
        }
    }
    
}
