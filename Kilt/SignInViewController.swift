//
//  SignInViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/1/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import Firebase
import FirebaseAuth

final class SignInViewController: UIViewController {
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: Icon.backIcon, style: UIBarButtonItemStyle.Plain,
                               target: self, action: #selector(popViewController))
    }()
    
    private lazy var negativeSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil).then {
        $0.width = -7
    }
    
    private lazy var emailTextField: UITextField = {
        return PaddingTextField(verticalPadding: 8, horizontalPadding: 10).then {
            $0.layer.cornerRadius = 6
            $0.keyboardType = .EmailAddress
            $0.autocapitalizationType = .None
            $0.backgroundColor = .whiteColor()
            let attributes = [
                NSForegroundColorAttributeName: UIColor.mountainMistColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "Email", attributes:attributes)
        }
    }()
    
    private lazy var passwordTextField: UITextField = {
        return PaddingTextField(verticalPadding: 8, horizontalPadding: 10).then {
            $0.layer.cornerRadius = 6
            $0.backgroundColor = .whiteColor()
            let attributes = [
                NSForegroundColorAttributeName: UIColor.mountainMistColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes:attributes)
            $0.secureTextEntry = true
        }
    }()
    
    private lazy var signInButton: UIButton = {
        return UIButton().then {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 6
            $0.backgroundColor = .whiteColor()
            $0.setTitleColor(.appColor(), forState: .Normal)
            $0.setTitle("Войти через почту", forState: .Normal)
            $0.setTitle("Подождите...", forState: .Disabled)
            $0.addTarget(self, action: #selector(loginWithEmail(_:)), forControlEvents: .TouchUpInside)
        }
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        navigationItem.leftBarButtonItems = [negativeSpace, leftBarButtonItem]
        view.backgroundColor = .appColor()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        [emailTextField, passwordTextField, signInButton].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(emailTextField, passwordTextField, signInButton, view) {
            emailTextField, passwordTextField, signInButton, view in
            emailTextField.top == view.top + 80
            emailTextField.leading == view.leading + 20
            emailTextField.trailing == view.trailing - 20
            emailTextField.height == 50
            
            passwordTextField.top == emailTextField.bottom + 15
            passwordTextField.leading == emailTextField.leading
            passwordTextField.trailing == emailTextField.trailing
            passwordTextField.height == emailTextField.height
            
            signInButton.top == passwordTextField.bottom + 15
            signInButton.leading == passwordTextField.leading
            signInButton.trailing == passwordTextField.trailing
            signInButton.height == passwordTextField.height
        }
    }
    
    // MARK: User Interaction
    
    @objc private func loginWithEmail(sender: UIButton) {
        guard let email = emailTextField.text where !email.isEmpty else {
            Drop.down("Введите email", state: .Error)
            return
        }
        
        guard let password = passwordTextField.text where !password.isEmpty else {
            Drop.down("Введите пароль", state: .Error)
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password) { user, error in
            guard let _ = user where error == nil else {
                Drop.down(error?.localizedDescription ?? "Ошибка", state: .Error)
                return
            }
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.loadMainPages()
        }
    }
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}
