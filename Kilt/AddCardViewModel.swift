//
//  AddCardViewModel.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/3/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseAuth

final class AddCardViewModel {
    
    func createCardWithName(name: String?, icon: UIImage?, barcode: String?, frontIcon: UIImage?,
                            backIcon: UIImage?, completion: (errorMessage: String?) -> Void) {
        guard let userKey = FIRAuth.auth()?.currentUser?.uid, barcode = barcode else {
            completion(errorMessage: nil)
            return
        }
        
        let company = Company(name: name, icon: nil)
        company.saveName { completion(errorMessage: $0?.localizedDescription) }
        guard let companyKey = company.ref?.key else {
            completion(errorMessage: nil)
            return
        }
        if let icon = icon, data = UIImageJPEGRepresentation(icon, 1.0) {
            StorageManager.saveLogo(companyKey, data: data) { (url, error) in
                if let error = error {
                    completion(errorMessage: error.localizedDescription)
                    return
                }
                company.icon = url?.absoluteString
                company.saveIcon() { completion(errorMessage: $0?.localizedDescription) }
            }
        }
        
        let card = Card(user: userKey, company: company, barcode: barcode, frontIcon: nil, backIcon: nil)
        card.saveUser { completion(errorMessage: $0?.localizedDescription) }
        card.saveCompany { completion(errorMessage: $0?.localizedDescription) }
        card.saveBarcode { completion(errorMessage: $0?.localizedDescription) }
        guard let cardKey = card.ref?.key else {
            completion(errorMessage: nil)
            return
        }
        User.addCard(cardKey) { completion(errorMessage: $0?.localizedDescription) }
        if let frontIcon = frontIcon, data = UIImageJPEGRepresentation(frontIcon, 1.0) {
            StorageManager.saveFrontIcon(cardKey, data: data) { (url, error) in
                if let error = error {
                    completion(errorMessage: error.localizedDescription)
                    return
                }
                card.frontIcon = url?.absoluteString
                card.saveFrontIcon() { completion(errorMessage: $0?.localizedDescription) }
            }
        }
        if let backIcon = backIcon, data = UIImageJPEGRepresentation(backIcon, 1.0) {
            StorageManager.saveBackIcon(cardKey, data: data) { (url, error) in
                if let error = error {
                    completion(errorMessage: error.localizedDescription)
                    return
                }
                card.backIcon = url?.absoluteString
                card.saveBackIcon() { completion(errorMessage: $0?.localizedDescription) }
            }
        }
    }
    
}
