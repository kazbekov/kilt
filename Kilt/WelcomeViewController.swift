//
//  WelcomeViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/1/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class WelcomeViewController: UIViewController {
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .whiteColor()
        $0.text = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as? String
    }
    
    private lazy var fbButton: UIButton = {
        return UIButton().then {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .facebookColor()
            $0.setTitleColor(.whiteColor(), forState: .Normal)
            $0.setTitle("Войти через Facebook", forState: .Normal)
            $0.setTitle("Подождите...", forState: .Disabled)
            $0.addTarget(self, action: #selector(loginWithFacebook(_:)), forControlEvents: .TouchUpInside)
        }
    }()
    
    private lazy var signInButton: UIButton = {
        return UIButton().then {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .whiteColor()
            $0.setTitleColor(.appColor(), forState: .Normal)
            $0.setTitle("Войти через почту", forState: .Normal)
            $0.addTarget(self, action: #selector(pushSignInViewController), forControlEvents: .TouchUpInside)
        }
    }()
    
    private lazy var signUpButton: UIButton = {
        return UIButton().then {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .whiteColor()
            $0.setTitleColor(.appColor(), forState: .Normal)
            $0.setTitle("Зарегистрироваться", forState: .Normal)
            $0.addTarget(self, action: #selector(pushSignUpViewController), forControlEvents: .TouchUpInside)
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
        view.backgroundColor = .appColor()
        [titleLabel, fbButton, signInButton, signUpButton].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, fbButton, signInButton, signUpButton, view) {
            titleLabel, fbButton, signInButton, signUpButton, view in
            titleLabel.top == view.top
            titleLabel.centerX == view.centerX
            
            signUpButton.bottom == view.bottom - 15
            signUpButton.leading == view.leading + 20
            signUpButton.trailing == view.trailing - 20
            signUpButton.height == 40
            
            signInButton.bottom == signUpButton.top - 15
            signInButton.leading == signUpButton.leading
            signInButton.trailing == signUpButton.trailing
            signInButton.height == signUpButton.height
            
            fbButton.bottom == signInButton.top - 15
            fbButton.leading == signInButton.leading
            fbButton.trailing == signInButton.trailing
            fbButton.height == signInButton.height
        }
    }
    
    // MARK: User Interaction
    
    @objc private func loginWithFacebook(sender: UIButton) {
        
    }
    
    @objc private func pushSignInViewController() {
    }
    
    @objc private func pushSignUpViewController() {
    }
    
}
