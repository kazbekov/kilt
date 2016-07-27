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
    
    private lazy var cardLogoView = CardLogoImageView(frame: .zero)
    
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
    
    private lazy var frontSelectImageView = SelectCardImageView(frame: .zero).then {
        $0.setUpWithPlaceholder(Icon.frontPlaceholderIcon, placeholderText: "Лицевая часть карты")
    }
    
    private lazy var backSelectImageView = SelectCardImageView(frame: .zero).then {
        $0.setUpWithPlaceholder(Icon.backPlaceholderIcon, placeholderText: "Обратная часть карты")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        [cardNumberTextField].forEach {
            $0.layer.cornerRadius = 6
        }
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .athensGrayColor()
        [cardLogoView, cardTitleTextField].forEach { cardLogoWrapper.addSubview($0) }
        [cardLogoWrapper, cardNumberTextField, frontSelectImageView, backSelectImageView].forEach { view.addSubview($0) }
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
        
        constrain(frontSelectImageView, backSelectImageView, cardNumberTextField, view) {
            frontSelectImageView, backSelectImageView, cardNumberTextField, view in
            frontSelectImageView.top == cardNumberTextField.bottom + 40
            frontSelectImageView.leading == view.leading + 20
            frontSelectImageView.width == (UIScreen.mainScreen().bounds.width - 60) / 2
            frontSelectImageView.height == frontSelectImageView.width * (100 / 158)
            
            backSelectImageView.top == frontSelectImageView.top
            backSelectImageView.trailing == view.trailing - 20
            backSelectImageView.width == frontSelectImageView.width
            backSelectImageView.height == frontSelectImageView.height
        }
    }
    
}
