//
//  Card.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/26/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseDatabase

final class Card {
    
    static var ref = FIRDatabase.database().reference().child("cards")
    
    var user: String?
    var company: Company?
    var barcode: String?
    var frontIcon: String?
    var backIcon: String?
    
    var ref: FIRDatabaseReference?
    
    init(user: String, company: Company, barcode: String,
         frontIcon: String?, backIcon: String?) {
        self.user = user
        self.company = company
        self.barcode = barcode
        self.frontIcon = frontIcon
        self.backIcon = backIcon
        ref = FIRDatabase.database().reference().child("cards").childByAutoId()
    }
    
    init(snapshot: FIRDataSnapshot, childChanged: () -> Void, completion: (card: Card) -> Void) {
        // TODO: make childChanged closure as variable!!!
        snapshot.ref.observeEventType(.Value) { snapshot in
            self.updateFromSnapshot(snapshot)
        }
        if let companyKey = snapshot.value?.objectForKey("company") as? String {
            Company.fetchCompany(companyKey, childChanged: childChanged) { company in
                self.company = company
                completion(card: self)
            }
        }
    }
    
    func updateFromSnapshot(snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        user = snapshot.value?.objectForKey("user") as? String
        barcode = snapshot.value?.objectForKey("barcode") as? String
        frontIcon = snapshot.value?.objectForKey("frontIcon") as? String
        backIcon = snapshot.value?.objectForKey("backIcon") as? String
    }
    
    func saveUser(completion: (error: NSError?) -> Void) {
        ref?.child("user").setValue(user) { error, ref in
            completion(error: error)
        }
    }
    
    func saveCompany(completion: (error: NSError?) -> Void) {
        ref?.child("company").setValue(company?.ref?.key) { error, ref in
            completion(error: error)
        }
    }
    
    func saveBarcode(completion: (error: NSError?) -> Void) {
        ref?.child("barcode").setValue(barcode) { error, ref in
            completion(error: error)
        }
    }
    
    func saveFrontIcon(completion: (error: NSError?) -> Void) {
        ref?.child("frontIcon").setValue(frontIcon) { error, ref in
            completion(error: error)
        }
    }
    
    func saveBackIcon(completion: (error: NSError?) -> Void) {
        ref?.child("backIcon").setValue(backIcon) { error, ref in
            completion(error: error)
        }
    }
    
    static func fetchCard(key: String, childChanged: () -> Void, completion: (card: Card) -> Void) {
        ref.child(key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let _ = Card(snapshot: snapshot, childChanged: childChanged) { card in
                completion(card: card)
            }
        })
    }
    
    static func fetchCards(childChanged: () -> Void, completion: (card: Card) -> Void) {
        User.fetchCards { (snapshot) in
            fetchCard(snapshot.key, childChanged: childChanged) { card in
                completion(card: card)
            }
        }
    }

}
