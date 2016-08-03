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
    
    private lazy var contactInfoView: ContactInfoView = ContactInfoView().then {
        $0.delegate = self
    }
    
    private lazy var logoImageView = LogoImageView(frame: .zero)
    
    private lazy var logoWrapper = UIView()
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .tundoraColor()
        $0.font = .systemFontOfSize(18)
    }
    
    private lazy var frontView = SelectCardView(frame: .zero).then {
        $0.setUpWithPlaceholderImage(Icon.frontPlaceholderIcon, placeholderText: "Лицевая часть карты")
    }
    
    private lazy var backView = SelectCardView(frame: .zero).then {
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
        [frontView, backView].forEach {
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
        [contactInfoView, logoWrapper, frontView, backView, barcodeView].forEach {
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
        
        constrain(frontView, backView, barcodeView, logoWrapper, view) {
            frontView, backView, barcodeView, logoWrapper, view in
            frontView.top == logoWrapper.bottom + 20
            frontView.leading == view.leading + 20
            frontView.width == (UIScreen.mainScreen().bounds.width - 60) / 2
            frontView.height == frontView.width * (100 / 158)
            
            backView.top == frontView.top
            backView.trailing == view.trailing - 20
            backView.width == frontView.width
            backView.height == frontView.height
            
            barcodeView.top == frontView.bottom + 20
            barcodeView.leading == view.leading + 20
            barcodeView.trailing == view.trailing - 20
        }
    }
    
    // MARK: User Interaction
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}

// MARK: ContactInfoViewDelegate

extension CardDetailViewController: ContactInfoViewDelegate {
    func makeCall(sender: UIButton) {
        guard let phoneNumber = sender.titleLabel?.text, phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)")
            else { return }
        let application = UIApplication.sharedApplication()
        if (application.canOpenURL(phoneCallURL)) {
            application.openURL(phoneCallURL);
        }
    }
}

extension CardDetailViewController {
    
    func setUpWithCard(card: Card2) {
        titleLabel.text = card.title
        contactInfoView.setUpWithAvatar(card.avatarImage, ownerName: card.ownerName, phoneNumber: card.phoneNumber)
        barcodeView.setUpWithBarcode(card.barcode)
    }
    
}
