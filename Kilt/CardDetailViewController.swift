//
//  CardDetailViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/26/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class CardDetailViewController: UIViewController {

    private lazy var leftBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: Icon.backIcon, style: UIBarButtonItemStyle.Plain,
                               target: self, action: #selector(popViewController))
    }()
    
    private lazy var negativeSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil).then {
        $0.width = -7
    }
    
    private lazy var contactInfoView: ContactInfoView = ContactInfoView()
    
    private lazy var logoImageView = LogoImageView(frame: .zero)
    
    private lazy var logoWrapper = UIView()
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .tundoraColor()
        $0.font = .systemFontOfSize(18)
    }
    
    private lazy var frontImageView = SelectCardImageView(frame: .zero).then {
        $0.setUpWithPlaceholderImage(Icon.frontPlaceholderIcon, placeholderText: "Лицевая часть карты")
    }
    
    private lazy var backImageView = SelectCardImageView(frame: .zero).then {
        $0.setUpWithPlaceholderImage(Icon.backPlaceholderIcon, placeholderText: "Обратная часть карты")
    }
    
    private lazy var barcodeView: BarcodeView = BarcodeView()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        [frontImageView, backImageView].forEach {
            $0.layer.cornerRadius = 6
        }
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .whiteColor()
        navigationItem.title = "Карточки"
        navigationItem.leftBarButtonItems = [negativeSpace, leftBarButtonItem]
        [logoImageView, titleLabel].forEach { logoWrapper.addSubview($0) }
        [contactInfoView, logoWrapper, frontImageView, backImageView, barcodeView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(contactInfoView, logoWrapper, view) {
            contactInfoView, logoWrapper, view in
            contactInfoView.top == view.top + 20
            contactInfoView.trailing == view.trailing - 10
            contactInfoView.width == 220
            contactInfoView.height == 75
            
            logoWrapper.top == contactInfoView.top
            logoWrapper.leading == view.leading
            logoWrapper.trailing == contactInfoView.leading
            logoWrapper.height == 90
        }
        
        constrain(logoImageView, titleLabel, logoWrapper) {
            logoImageView, cardLogoLabel, logoWrapper in
            logoImageView.top == logoWrapper.top
            logoImageView.centerX == logoWrapper.centerX
            logoImageView.height == 55
            logoImageView.width == 55
            
            cardLogoLabel.top == logoImageView.bottom + 9
            cardLogoLabel.centerX == logoImageView.centerX
        }
        
        constrain(frontImageView, backImageView, barcodeView, logoWrapper, view) {
            frontImageView, backImageView, barcodeView, logoWrapper, view in
            frontImageView.top == logoWrapper.bottom + 20
            frontImageView.leading == view.leading + 20
            frontImageView.width == (UIScreen.mainScreen().bounds.width - 60) / 2
            frontImageView.height == frontImageView.width * (100 / 158)
            
            backImageView.top == frontImageView.top
            backImageView.trailing == view.trailing - 20
            backImageView.width == frontImageView.width
            backImageView.height == frontImageView.height
            
            barcodeView.top == frontImageView.bottom + 20
            barcodeView.leading == view.leading + 20
            barcodeView.trailing == view.trailing - 20
        }
    }
    
    // MARK: User Interaction
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}

extension CardDetailViewController {
    
    func setUpWithCard(card: Card) {
        titleLabel.text = card.title
        logoImageView.setUpWithTitle(card.title)
        contactInfoView.setUpWithAvatar(card.avatarImage, ownerName: card.ownerName, phoneNumber: card.phoneNumber)
        frontImageView.setUpWithImage(nil)
        backImageView.setUpWithImage(nil)
        barcodeView.setUpWithBarcode(card.barcode)
    }
    
}
