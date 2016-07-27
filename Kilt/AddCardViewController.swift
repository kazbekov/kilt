//
//  AddCardViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class AddCardViewController: UIViewController {
    
    private lazy var cardLogoWrapper = UIView().then {
        $0.backgroundColor = .whiteColor()
    }
    
    private lazy var cardLogoView: CardLogoView = CardLogoView()
    
    private lazy var cardTitleTextField: UITextField = {
        return UITextField().then {
            let attributes = [
                NSForegroundColorAttributeName: UIColor.mountainMistColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(17)
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "Ввести название карты...", attributes:attributes)
        }
    }()
    
    private lazy var cardNumberTextField: CardNumberTextField = {
        return CardNumberTextField().then {
            $0.backgroundColor = .whiteColor()
            let attributes = [
                NSForegroundColorAttributeName: UIColor.mountainMistColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "Введите номер карты вручную...", attributes:attributes)
        }
    }()
    
    private lazy var frontImageView = UIImageView().then {
        $0.backgroundColor = .tundoraColor()
        $0.contentMode = .ScaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var backImageView = UIImageView().then {
        $0.backgroundColor = .tundoraColor()
        $0.contentMode = .ScaleAspectFill
        $0.clipsToBounds = true
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        [frontImageView, backImageView, cardNumberTextField].forEach {
            $0.layer.cornerRadius = 6
        }
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        view.backgroundColor = .athensGrayColor()
        [cardLogoView, cardTitleTextField].forEach { cardLogoWrapper.addSubview($0) }
        [cardLogoWrapper, cardNumberTextField, frontImageView, backImageView].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(cardLogoWrapper, cardNumberTextField, view) {
            cardLogoWrapper, cardNumberTextField, view in
            cardLogoWrapper.top == view.top
            cardLogoWrapper.leading == view.leading
            cardLogoWrapper.trailing == view.trailing
            cardLogoWrapper.height == view.width - 225 - 16
            
            cardNumberTextField.top == cardLogoWrapper.bottom + 16
            cardNumberTextField.leading == view.leading + 16
            cardNumberTextField.trailing == view.trailing - 16
            cardNumberTextField.height == 50
        }
        
        constrain(cardLogoView, cardTitleTextField, cardLogoWrapper) {
            cardLogoView, cardTitleTextField, cardLogoWrapper in
            cardTitleTextField.trailing == cardLogoWrapper.trailing - 16
            cardTitleTextField.centerY == cardLogoWrapper.centerY
            cardTitleTextField.width == 225
            
            cardLogoView.leading == cardLogoWrapper.leading + 16
            cardLogoView.trailing == cardTitleTextField.leading - 16
            cardLogoView.centerY == cardLogoWrapper.centerY
            cardLogoView.height == cardLogoView.width
        }
        
        constrain(frontImageView, backImageView, cardNumberTextField, view) {
            frontImageView, backImageView, cardNumberTextField, view in
            frontImageView.top == cardNumberTextField.bottom + 40
            frontImageView.leading == view.leading + 20
            frontImageView.width == (UIScreen.mainScreen().bounds.width - 60) / 2
            frontImageView.height == frontImageView.width * (100 / 158)
            
            backImageView.top == frontImageView.top
            backImageView.trailing == view.trailing - 20
            backImageView.width == frontImageView.width
            backImageView.height == frontImageView.height
        }
    }
    
}
