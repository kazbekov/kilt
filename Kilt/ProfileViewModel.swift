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
            guard error == nil else {
                completion(errorMessage: error?.localizedDescription ?? "Ошибка")
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
                guard let _ = user where error == nil else {
                    completion(errorMessage: error?.localizedDescription ?? "Ошибка")
                    return
                }
                completion(errorMessage: nil)
            }
        }
    }
    
    func unlinkEmail(completion: (errorMessage: String?) -> Void) {
        FIRAuth.auth()?.currentUser?.unlinkFromProvider(passwordProviderId) { user, error in
            guard error == nil else {
                completion(errorMessage: error?.localizedDescription ?? "Ошибка")
                return
            }
            completion(errorMessage: nil)
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
            guard let _ = user where error == nil else {
                completion(errorMessage: error?.localizedDescription ?? "Ошибка")
                return
            }
            completion(errorMessage: nil)
        }
    }
    
}

