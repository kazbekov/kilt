//
//  SignUpViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/1/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class SignUpViewController: UIViewController {
    
    private var viewModel = SignUpViewModel()
    
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
    
    private lazy var signUpButton: UIButton = {
        return UIButton().then {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .whiteColor()
            $0.setTitleColor(.appColor(), forState: .Normal)
            $0.setTitle("Зарегистрироваться", forState: .Normal)
            $0.setTitle("Подождите...", forState: .Disabled)
            $0.addTarget(self, action: #selector(registerWithEmail(_:)), forControlEvents: .TouchUpInside)
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
        [emailTextField, passwordTextField, signUpButton].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(emailTextField, passwordTextField, signUpButton, view) {
            emailTextField, passwordTextField, signUpButton, view in
            emailTextField.top == view.top + 80
            emailTextField.leading == view.leading + 20
            emailTextField.trailing == view.trailing - 20
            emailTextField.height == 50
            
            passwordTextField.top == emailTextField.bottom + 15
            passwordTextField.leading == emailTextField.leading
            passwordTextField.trailing == emailTextField.trailing
            passwordTextField.height == emailTextField.height
            
            signUpButton.top == passwordTextField.bottom + 15
            signUpButton.leading == passwordTextField.leading
            signUpButton.trailing == passwordTextField.trailing
            signUpButton.height == passwordTextField.height
        }
    }
    
    // MARK: User Interaction
    
    @objc private func registerWithEmail(sender: UIButton) {
        dispatch { sender.enabled = false }
        viewModel.registerWithEmail(emailTextField.text, password: passwordTextField.text) {
            errorMessage in
            dispatch {
                sender.enabled = true
                if let errorMessage = errorMessage {
                    Drop.down(errorMessage, state: .Error)
                    return
                }
                (UIApplication.sharedApplication().delegate as? AppDelegate)?.loadMainPages()
            }
        }
    }
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}
