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
import RSBarcodes_Swift
import AVFoundation

final class AddCardViewController: UIViewController {
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: Icon.backIcon, style: UIBarButtonItemStyle.Plain,
                               target: self, action: #selector(popViewController))
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Сохранить", style: .Plain, target: self, action: #selector(saveCard)).then {
            $0.setTitleTextAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(17)], forState: .Normal)
        }
    }()
    
    private lazy var negativeSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil).then {
        $0.width = -7
    }
    
    private lazy var cardLogoWrapper = UIView().then {
        $0.backgroundColor = .whiteColor()
    }
    
    private lazy var cardLogoImageView = CardLogoImageView(frame: .zero)
    
    private lazy var cardTitleTextField: UITextField = {
        return UITextField().then {
            $0.addTarget(self, action: #selector(updateCardLogoImageView(_:)),
                forControlEvents: .EditingChanged)
            $0.tag = 1
            let attributes = [
                NSForegroundColorAttributeName: UIColor.mountainMistColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(17)
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "Ввести название карты...", attributes:attributes)
        }
    }()
    
    private lazy var barcodeTextField: BarcodeTextField = {
        return BarcodeTextField().then {
            $0.addTarget(self, action: #selector(generateBarcodeImage(_:)),
                forControlEvents: .EditingChanged)
            $0.backgroundColor = .whiteColor()
            let attributes = [
                NSForegroundColorAttributeName: UIColor.mountainMistColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "Введите номер карты вручную...", attributes:attributes)
        }
    }()
    
    private lazy var frontSelectImageView = SelectCardImageView(frame: .zero).then {
        $0.setUpWithPlaceholderImage(Icon.frontPlaceholderIcon, placeholderText: "Лицевая часть карты")
    }
    
    private lazy var backSelectImageView = SelectCardImageView(frame: .zero).then {
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
        [barcodeTextField].forEach {
            $0.layer.cornerRadius = 6
        }
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .athensGrayColor()
        navigationItem.title = "Карта"
        navigationItem.leftBarButtonItems = [negativeSpace, leftBarButtonItem]
        navigationItem.rightBarButtonItem = rightBarButtonItem
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        [cardLogoImageView, cardTitleTextField].forEach { cardLogoWrapper.addSubview($0) }
        [cardLogoWrapper, barcodeTextField, frontSelectImageView, backSelectImageView, barcodeView]
            .forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(cardLogoWrapper, barcodeTextField, view) {
            cardLogoWrapper, barcodeTextField, view in
            cardLogoWrapper.top == view.top
            cardLogoWrapper.leading == view.leading
            cardLogoWrapper.trailing == view.trailing
            cardLogoWrapper.height == view.width - 225 - 16
            
            barcodeTextField.top == cardLogoWrapper.bottom + 16
            barcodeTextField.leading == view.leading + 16
            barcodeTextField.trailing == view.trailing - 16
            barcodeTextField.height == 50
        }
        
        constrain(cardLogoImageView, cardTitleTextField, cardLogoWrapper) {
            cardLogoImageView, cardTitleTextField, cardLogoWrapper in
            cardTitleTextField.trailing == cardLogoWrapper.trailing - 16
            cardTitleTextField.centerY == cardLogoWrapper.centerY
            cardTitleTextField.width == 225
            
            cardLogoImageView.leading == cardLogoWrapper.leading + 16
            cardLogoImageView.trailing == cardTitleTextField.leading - 16
            cardLogoImageView.centerY == cardLogoWrapper.centerY
            cardLogoImageView.height == cardLogoImageView.width
        }
        
        constrain(frontSelectImageView, backSelectImageView, barcodeTextField, view) {
            frontSelectImageView, backSelectImageView, barcodeTextField, view in
            frontSelectImageView.top == barcodeTextField.bottom + 20
            frontSelectImageView.leading == view.leading + 20
            frontSelectImageView.width == (UIScreen.mainScreen().bounds.width - 60) / 2
            frontSelectImageView.height == frontSelectImageView.width * (100 / 158)
            
            backSelectImageView.top == frontSelectImageView.top
            backSelectImageView.trailing == view.trailing - 20
            backSelectImageView.width == frontSelectImageView.width
            backSelectImageView.height == frontSelectImageView.height
        }
        
        constrain(frontSelectImageView, barcodeView, view) {
            frontSelectImageView, barcodeView, view in
            barcodeView.top == frontSelectImageView.bottom + 20
            barcodeView.leading == view.leading + 20
            barcodeView.trailing == view.trailing - 20
        }
    }
    
    // MARK: User Interaction
    
    @objc private func saveCard() {
        
    }
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @objc private func updateCardLogoImageView(sender: UITextField) {
        cardLogoImageView.setUpWithTitle(sender.text)
    }
    
    @objc private func generateBarcodeImage(sender: UITextField) {
        guard let text = sender.text, image = RSUnifiedCodeGenerator.shared
            .generateCode(text, machineReadableCodeObjectType: AVMetadataObjectTypeCode39Code)
            where !text.isEmpty else { return }
        barcodeView.setUpWithImage(image, barcode: text)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}

extension AddCardViewController {
    
    func setUpWithBarcode(barcode: String?) {
        barcodeTextField.text = barcode
        generateBarcodeImage(barcodeTextField)
    }
    
}
