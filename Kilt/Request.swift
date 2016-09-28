//
//  Request.swift
//  Kilt
//
//  Created by Dias Dosymbaev on 9/16/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

final class Request {
    static var ref = FIRDatabase.database().reference().child("requests")

    var uid: String?
    var email: String?
    var number: String?
    var companyName: String?
    var companyIsVerified: Bool?
    var icon: String?

    var ref: FIRDatabaseReference?

    init(companyName: String?, uid: String?, email: String?, number: String?, companyIsVerified: Bool?, icon: String?) {
        self.companyName = companyName
        self.uid = uid
        self.email = email
        self.number = number
        self.companyIsVerified = companyIsVerified
        self.icon = icon
        ref = FIRDatabase.database().reference().child("requests").childByAutoId()
    }

    init(snapshot: FIRDataSnapshot, childChanged: () -> Void) {
        updateFromSnapshot(snapshot)
        snapshot.ref.observeEventType(.Value, withBlock: { snapshot in
            self.updateFromSnapshot(snapshot)
            childChanged()
        })
    }

    func updateFromSnapshot(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        uid = snapshot.value?.objectForKey("uid") as? String
        email = snapshot.value?.objectForKey("email") as? String
        number = snapshot.value?.objectForKey("number") as? String
        companyName = snapshot.value?.objectForKey("companyName") as? String
        companyIsVerified = snapshot.value?.objectForKey("companyIsVerified") as? Bool
        icon = snapshot.value?.objectForKey("icon") as? String
    }

    func saveCompanyName(companyName: String, completion: (error: NSError?) -> Void) {
        ref?.child("companyName").setValue(companyName) { error, ref in
            completion(error: error)
        }
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

    func saveIcon(icon: String, completion: (error: NSError?) -> Void) {
        ref?.child("icon").setValue(icon) { error, ref in
            completion(error: error)
        }
    }

    func saveNumber(number: String, completion: (error: NSError?) -> Void) {
        ref?.child("number").setValue(number) {error, ref in
            completion(error: error)
        }
    }

    func saveIsVerified(companyIsVerified: Bool, completion: (error: NSError?) -> Void) {
        ref?.child("companyIsVerified").setValue(companyIsVerified) {error, ref in
            completion(error: error)
        }
    }

    static func fetchRequest(key: String, childChanged: () -> Void, completion: (request: Request) -> Void) {
        ref.child(key).observeSingleEventOfType(.Value) { snapshot in
            completion(request: Request(snapshot: snapshot, childChanged: childChanged))
        }
    }

    static func fetchRequests(completion: (snapshot: FIRDataSnapshot) -> Void) {
        ref.observeEventType(.ChildAdded) { snapshot in
            completion(snapshot: snapshot)
        }
    }
}
