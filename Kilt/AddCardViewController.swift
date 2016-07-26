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

final class AddCardViewController: UIViewController {
    
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
    
    private lazy var cardLogoLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .tundoraColor()
        $0.font = .systemFontOfSize(18)
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .whiteColor()
        navigationItem.title = "Карточки"
        navigationItem.leftBarButtonItems = [negativeSpace, leftBarButtomItem]
        [cardLogoView, cardLogoLabel].forEach { cardLogoWrapper.addSubview($0) }
        [contactInfoView, cardLogoWrapper].forEach {
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
        
        constrain(cardLogoView, cardLogoLabel, cardLogoWrapper) {
            cardLogoView, cardLogoLabel, cardLogoWrapper in
            cardLogoView.top == cardLogoWrapper.top
            cardLogoView.centerX == cardLogoWrapper.centerX
            cardLogoView.height == 55
            cardLogoView.width == 55
            
            cardLogoLabel.top == cardLogoView.bottom + 9
            cardLogoLabel.centerX == cardLogoView.centerX
        }
    }
    
    // MARK: User Interaction
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
