//
//  ProfileViewModel.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/2/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseDatabase

final class ProfileViewModel {
    
    private let facebookProviderId = "facebook.com"
    private let passwordProviderId = "password"
    
    private var facebookDisplayName: String? {
        return FIRAuth.auth()?.currentUser?.providerData.filter { $0.providerID == facebookProviderId }.first?.displayName
    }
    
    private var emailDisplayName: String? {
        return FIRAuth.auth()?.currentUser?.providerData.filter { $0.providerID == passwordProviderId }.first?.email
    }
    
    var isLinkedWithFacebook: Bool {
        return FIRAuth.auth()?.currentUser?.providerData.filter({ $0.providerID == facebookProviderId }).count != 0
    }
    
    var isLinkedWithEmail: Bool {
        return FIRAuth.auth()?.currentUser?.providerData.filter({ $0.providerID == passwordProviderId }).count != 0
    }

    var isVerified = false
    
    var cellItems: [[ProfileCellItem]] {
        return [
            [
                ProfileCellItem(title: "Facebook", subtitle: facebookDisplayName ?? "Добавить",
                    icon: Icon.facebookIcon),
                ProfileCellItem(title: "Email", subtitle: emailDisplayName ?? "Добавить",
                    icon: Icon.mailIcon)
            ],
            [
                ProfileCellItem(title: "Выйти", subtitle: nil,
                    icon: Icon.exitIcon, titleColor: .crimsonColor())
            ]
        ]
    }
    
    func signOut(completion: (errorMessage: String?) -> Void) {
        do {
            try FIRAuth.auth()?.signOut()
            completion(errorMessage: nil)
        } catch {
            completion(errorMessage: "Ошибка")
        }
    }
    
    func unlinkFacebook(completion: (errorMessage: String?) -> Void) {
        FIRAuth.auth()?.currentUser?.unlinkFromProvider(facebookProviderId) { user, error in
            if let error = error {
                completion(errorMessage: error.localizedDescription)
                return
            }
            completion(errorMessage: nil)
        }
    }
    
    func linkFacebook(viewController: UIViewController, completion: (errorMessage: String?) -> Void) {
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile"], fromViewController: viewController) { result, error in
            guard error == nil && !result.isCancelled else {
                completion(errorMessage: error?.localizedDescription ?? "Отменено")
                return
            }
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(
                FBSDKAccessToken.currentAccessToken().tokenString)
            FIRAuth.auth()?.currentUser?.linkWithCredential(credential) { user, error in
                if let error = error {
                    completion(errorMessage: error.localizedDescription)
                    return
                }
                completion(errorMessage: nil)
            }
        }
    }
    
    func unlinkEmail(completion: (errorMessage: String?) -> Void) {
        FIRAuth.auth()?.currentUser?.unlinkFromProvider(passwordProviderId) { user, error in
            if let error = error {
                completion(errorMessage: error.localizedDescription)
                return
            }
            self.reloadUser(completion)
        }
    }
    
    func linkEmail(email: String?, password: String?, completion: (errorMessage: String?) -> Void) {
        guard let email = email where !email.isEmpty else {
            completion(errorMessage: "Введите email")
            return
        }
        
        guard let password = password where !password.isEmpty else {
            completion(errorMessage: "Введите пароль")
            return
        }
        
        let credential = FIREmailPasswordAuthProvider.credentialWithEmail(email, password: password)
        FIRAuth.auth()?.currentUser?.linkWithCredential(credential) { user, error in
            if let error = error {
                completion(errorMessage: error.localizedDescription)
                return
            }
            self.reloadUser(completion)
        }
    }

    func linkRequest(email: String?, number: String?, completion : (errorMessage: String?) -> Void) {
        guard let email = email where !email.isEmpty else {
            completion(errorMessage: "Введите email")
            return
        }

        guard let number = number where !number.isEmpty else {
            completion(errorMessage: "Введите номер телефона")
            return
        }

        let usersRef = FIRDatabase.database().reference().child("users")

        guard let userKey = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        usersRef.child(userKey+"/isVerified").setValue(false)

        let request = Request(uid: userKey, email: email, number: number)
        request.saveRequest(userKey) {completion(errorMessage: $0?.localizedDescription) }
        request.saveEmail(email) {completion(errorMessage: $0?.localizedDescription) }
        request.saveNumber(number) {completion(errorMessage: $0?.localizedDescription) }
    }
    
    func saveUserWithName(name: String?, address: String?, icon: UIImage?, completion: (errorMessage: String?) -> Void) {
        User.saveName(name) { completion(errorMessage: $0?.localizedDescription) }
        User.saveAddress(address) { completion(errorMessage: $0?.localizedDescription) }
        guard let icon = icon, data = UIImageJPEGRepresentation(icon, 0.7) else {
            completion(errorMessage: nil)
            return
        }
        StorageManager.saveAvatar(data) {
            downloadURL, error in
            if let error = error {
                completion(errorMessage: error.localizedDescription)
                return
            }
            User.saveIcon(downloadURL?.absoluteString) { completion(errorMessage: $0?.localizedDescription) }
        }
    }
    
    func fetchName(completion: (String?) -> Void) {
        User.fetchName { completion($0 ?? self.facebookDisplayName) }
    }
    
    func fetchAddress(completion: (String?) -> Void) {
        User.fetchAddress { completion($0) }
    }
    
    func fetchIcon(completion: (NSURL?) -> Void) {
        User.fetchIcon { urlString in
            guard let urlString = urlString else {
                completion(nil)
                return
            }
            completion(NSURL(string: urlString))
        }
    }
    
    func reloadUser(completion: (errorMessage: String?) -> Void) {
        FIRAuth.auth()?.currentUser?.reloadWithCompletion({ error in
            if let error = error {
                completion(errorMessage: error.localizedDescription)
                return
            }
            completion(errorMessage: nil)
        })
    }

    func sendRequest(user: User,completion: (errorMessage: String?) -> Void){
        
    }
    
}

