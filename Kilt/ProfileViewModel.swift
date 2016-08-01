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
    
    var isLinkedWithFacebook: Bool {
        return FIRAuth.auth()?.currentUser?.providerData.filter({ $0.providerID == facebookProviderId }).count == 0
    }
    
    var facebookDisplayName: String? {
        return FIRAuth.auth()?.currentUser?.providerData.filter { $0.providerID == facebookProviderId }.first?.displayName
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
                completion(errorMessage: error?.localizedDescription ?? "Ошибка")
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
}

