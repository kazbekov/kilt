//
//  AddCardViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/26/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class CardDetailViewController: UIViewController {

    private lazy var leftBarButtomItem: UIBarButtonItem = {
        return UIBarButtonItem(image: Icon.backIcon, style: UIBarButtonItemStyle.Plain,
                               target: self, action: #selector(popViewController))
    }()
    
    private lazy var negativeSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil).then {
        $0.width = -7
    }
    
    private lazy var contactInfoView: ContactInfoView = ContactInfoView()
    
    private lazy var cardLogoView: CardLogoView = CardLogoView()
    
    private lazy var cardLogoWrapper = UIView()
    
    private lazy var cardTitleLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .tundoraColor()
        $0.font = .systemFontOfSize(18)
    }
    
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
        [frontImageView, backImageView].forEach {
            $0.layer.cornerRadius = 6
        }
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .whiteColor()
        navigationItem.title = "Карточки"
        navigationItem.leftBarButtonItems = [negativeSpace, leftBarButtomItem]
        [cardLogoView, cardTitleLabel].forEach { cardLogoWrapper.addSubview($0) }
        [contactInfoView, cardLogoWrapper, frontImageView, backImageView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(contactInfoView, cardLogoWrapper, view) {
            contactInfoView, cardLogoWrapper, view in
            contactInfoView.top == view.top + 30
            contactInfoView.trailing == view.trailing - 10
            contactInfoView.width == 220
            contactInfoView.height == 75
            
            cardLogoWrapper.top == view.top + 30
            cardLogoWrapper.leading == view.leading
            cardLogoWrapper.trailing == contactInfoView.leading
            cardLogoWrapper.height == 90
        }
        
        constrain(cardLogoView, cardTitleLabel, cardLogoWrapper) {
            cardLogoView, cardLogoLabel, cardLogoWrapper in
            cardLogoView.top == cardLogoWrapper.top
            cardLogoView.centerX == cardLogoWrapper.centerX
            cardLogoView.height == 55
            cardLogoView.width == 55
            
            cardLogoLabel.top == cardLogoView.bottom + 9
            cardLogoLabel.centerX == cardLogoView.centerX
        }
        
        constrain(frontImageView, backImageView, cardLogoWrapper, view) {
            frontImageView, backImageView, cardLogoWrapper, view in
            frontImageView.top == cardLogoWrapper.bottom + 40
            frontImageView.leading == view.leading + 20
            frontImageView.width == (UIScreen.mainScreen().bounds.width - 60) / 2
            frontImageView.height == frontImageView.width * (100 / 158)
            
            backImageView.top == frontImageView.top
            backImageView.trailing == view.trailing - 20
            backImageView.width == frontImageView.width
            backImageView.height == frontImageView.height
        }
    }
    
    // MARK: User Interaction
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}

extension CardDetailViewController {
    func setUpWithCard(card: Card) {
        cardLogoView.setUpWithTitle(card.title)
        cardTitleLabel.text = card.title
        contactInfoView.setUpWithContact(card.avatarImage, ownerName: card.ownerName, phoneNumber: card.phoneNumber)
    }
}
