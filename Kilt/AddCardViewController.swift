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
    
    private lazy var logoWrapper = UIView().then {
        $0.backgroundColor = .whiteColor()
    }
    
    private lazy var logoImageView = LogoImageView(frame: .zero)
    
    private lazy var titleTextField: UITextField = {
        return UITextField().then {
            $0.addTarget(self, action: #selector(updateLogoImageView(_:)),
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
        [logoImageView, titleTextField].forEach { logoWrapper.addSubview($0) }
        [logoWrapper, barcodeTextField, frontSelectImageView, backSelectImageView, barcodeView]
            .forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(logoWrapper, barcodeTextField, view) {
            logoWrapper, barcodeTextField, view in
            logoWrapper.top == view.top
            logoWrapper.leading == view.leading
            logoWrapper.trailing == view.trailing
            logoWrapper.height == view.width - 225 - 16
            
            barcodeTextField.top == logoWrapper.bottom + 16
            barcodeTextField.leading == view.leading + 16
            barcodeTextField.trailing == view.trailing - 16
            barcodeTextField.height == 50
        }
        
        constrain(logoImageView, titleTextField, logoWrapper) {
            logoImageView, titleTextField, logoWrapper in
            titleTextField.top == logoWrapper.top
            titleTextField.trailing == logoWrapper.trailing - 16
            titleTextField.bottom == logoWrapper.bottom
            titleTextField.width == 225
            
            logoImageView.leading == logoWrapper.leading + 16
            logoImageView.trailing == titleTextField.leading - 16
            logoImageView.centerY == logoWrapper.centerY
            logoImageView.height == logoImageView.width
        }
        
        constrain(frontSelectImageView, backSelectImageView, barcodeView, barcodeTextField, view) {
            frontSelectImageView, backSelectImageView, barcodeView, barcodeTextField, view in
            frontSelectImageView.top == barcodeTextField.bottom + 20
            frontSelectImageView.leading == view.leading + 20
            frontSelectImageView.width == (UIScreen.mainScreen().bounds.width - 60) / 2
            frontSelectImageView.height == frontSelectImageView.width * (100 / 158)
            
            backSelectImageView.top == frontSelectImageView.top
            backSelectImageView.trailing == view.trailing - 20
            backSelectImageView.width == frontSelectImageView.width
            backSelectImageView.height == frontSelectImageView.height
            
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
    
    @objc private func updateLogoImageView(sender: UITextField) {
        logoImageView.setUpWithTitle(sender.text)
    }
    
    @objc private func generateBarcodeImage(sender: UITextField) {
        barcodeView.setUpWithBarcode(sender.text)
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
