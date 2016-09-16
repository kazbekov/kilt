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
    
    private let viewModel = WelcomeViewModel()
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .whiteColor()
        $0.font = .boldSystemFontOfSize(30)
        $0.text = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as? String
    }
    
    private lazy var subtitleLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .whiteColor()
        $0.font = .boldSystemFontOfSize(17)
        $0.text = "Кошелек для клубных карт лояльности"
        $0.numberOfLines = 0
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
    
    private lazy var logoImageView: UIImageView = {
        return UIImageView().then {
            $0.contentMode = .ScaleAspectFill
            $0.image = UIImage(named: "logo")
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        view.backgroundColor = .appColor()
        [titleLabel, subtitleLabel, logoImageView, fbButton, signInButton, signUpButton].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        
        constrain(titleLabel, logoImageView,fbButton, signInButton, signUpButton) {
            titleLabel, logoImageView, fbButton, signInButton, signUpButton in
            titleLabel.top == titleLabel.superview!.top + 50
            titleLabel.centerX == titleLabel.superview!.centerX
            
            logoImageView.top == logoImageView.superview!.top + 100
            logoImageView.centerX == logoImageView.superview!.centerX
            logoImageView.height == 128
            logoImageView.width == 128
            
            signUpButton.bottom == logoImageView.superview!.bottom - 15
            signUpButton.leading == logoImageView.superview!.leading + 20
            signUpButton.trailing == logoImageView.superview!.trailing - 20
            signUpButton.height == 50
            
            signInButton.bottom == signUpButton.top - 15
            signInButton.leading == signUpButton.leading
            signInButton.trailing == signUpButton.trailing
            signInButton.height == signUpButton.height
            
            fbButton.bottom == signInButton.top - 15
            fbButton.leading == signInButton.leading
            fbButton.trailing == signInButton.trailing
            fbButton.height == signInButton.height
        }
        constrain(titleLabel,subtitleLabel) {
            titleLabel, subtitleLabel in
            
            subtitleLabel.top == titleLabel.bottom + 200
            subtitleLabel.centerX == subtitleLabel.superview!.centerX
            subtitleLabel.leading == subtitleLabel.superview!.leading + 20
            subtitleLabel.trailing == subtitleLabel.superview!.trailing - 20
            
        }
    }
    
    // MARK: User Interaction
    
    @objc private func loginWithFacebook(sender: UIButton) {
        dispatch { sender.enabled = false }
        viewModel.loginWithFacebook(self) { errorMessage in
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
    
    @objc private func pushSignInViewController() {
        dispatch { self.navigationController?.pushViewController(SignInViewController(), animated: true) }
    }
    
    @objc private func pushSignUpViewController() {
        dispatch { self.navigationController?.pushViewController(SignUpViewController(), animated: true) }
    }
    
}
