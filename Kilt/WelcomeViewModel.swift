//
//  WelcomeViewModel.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/1/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

final class WelcomeViewModel {
    
    func loginWithFacebook(viewController: UIViewController, completion: (errorMessage: String?) -> Void) {
        let loginManager = FBSDKLoginManager()

        loginManager.logInWithReadPermissions(["public_profile"], fromViewController: viewController) { result, error in
            guard error == nil && !result.isCancelled else {
                completion(errorMessage: error?.localizedDescription ?? "Отменено")
                return
            }
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(
                FBSDKAccessToken.currentAccessToken().tokenString)
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                guard let _ = user where error == nil else {
                    completion(errorMessage: error?.localizedDescription ?? "Ошибка")
                    return
                }
                completion(errorMessage: nil)
            }
        }
    }
    
}
