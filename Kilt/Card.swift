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
    
    var user: String?
    var company: String?
    var barcode: String?
    var frontIcon: String?
    var backIcon: String?
    
    var ref: FIRDatabaseReference?
    
    init(key: String?, user: String?, company: String?, barcode: String?,
         frontIcon: String?, backIcon: String?) {
        self.user = user
        self.company = company
        self.barcode = barcode
        self.frontIcon = frontIcon
        self.backIcon = backIcon
        if let key = key {
            ref = FIRDatabase.database().reference().child("cards/\(key)")
        } else {
            ref = FIRDatabase.database().reference().child("cards").childByAutoId()
        }
    }
    
    func saveUser(completion: (error: NSError?) -> Void) {
        ref?.child("user").setValue(user) { error, ref in
            completion(error: error)
        }
    }
    
    func saveCompany(completion: (error: NSError?) -> Void) {
        ref?.child("company").setValue(company) { error, ref in
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

}
