//
//  Card.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/26/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct Card2 {
    var title: String?
    var barcode: String?
    var ownerName: String?
    var phoneNumber: String?
    var avatarImage: UIImage?
}

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
    
    init(snapshot: FIRDataSnapshot, completion: (card: Card) -> Void) {
        ref = snapshot.ref
        user = snapshot.value?.objectForKey("user") as? String
        barcode = snapshot.value?.objectForKey("barcode") as? String
        frontIcon = snapshot.value?.objectForKey("frontIcon") as? String
        backIcon = snapshot.value?.objectForKey("backIcon") as? String
        
        if let companyKey = snapshot.value?.objectForKey("company") as? String {
            Company.fetchCompany(companyKey) { company in
                self.company = company
                completion(card: self)
            }
        }
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
    
    static func fetchCard(key: String, completion: (card: Card) -> Void) {
        ref.child(key).observeSingleEventOfType(.Value) { snapshot in
            completion(card: Card(snapshot: snapshot, completion: completion))
        }
    }
    
    static func fetchCards(completion: (card: Card) -> Void) {
        User.fetchCards { (snapshot) in
            fetchCard(snapshot.key, completion: { card in
                completion(card: card)
            })
        }
    }

}
