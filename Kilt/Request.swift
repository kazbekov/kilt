//
//  Request.swift
//  Kilt
//
//  Created by Dias Dosymbaev on 9/16/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class Request {
    static var ref = FIRDatabase.database().reference().child("requests")

    var uid: String?
    var email: String?
    var number: String?

    var ref: FIRDatabaseReference?

    init(uid: String?, email: String?, number: String?) {
        self.uid = uid
        self.email = email
        self.number = number
        ref = FIRDatabase.database().reference().child("requests").childByAutoId()
    }

    func saveRequest(uid: String, completion: (error: NSError?) -> Void) {
        ref?.child("uid").setValue(uid) { error, ref in
            completion(error: error)
        }
    }

    func saveEmail(email: String, completion: (error: NSError?) -> Void) {
        ref?.child("email").setValue(email) {error, ref in
            completion(error: error)
        }
    }

    func saveNumber(number: String, completion: (error: NSError?) -> Void) {
        ref?.child("number").setValue(number) {error, ref in
            completion(error: error)
        }
    }
}
