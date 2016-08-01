//
//  SignUpViewModel.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/2/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import Foundation
import FirebaseAuth

final class SignUpViewModel {
    
    func registerWithEmail(email: String?, password: String?, completion: (errorMessage: String?) -> Void) {
        guard let email = email where !email.isEmpty else {
            completion(errorMessage: "Введите email")
            return
        }
        
        guard let password = password where !password.isEmpty else {
            completion(errorMessage: "Введите пароль")
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { user, error in
            guard let _ = user where error == nil else {
                completion(errorMessage: error?.localizedDescription ?? "Ошибка")
                return
            }
            
            FIRAuth.auth()?.signInWithEmail(email, password: password) { user, error in
                guard let _ = user where error == nil else {
                    completion(errorMessage: error?.localizedDescription ?? "Ошибка")
                    return
                }
                completion(errorMessage: nil)
            }
        }
    }
    
}
