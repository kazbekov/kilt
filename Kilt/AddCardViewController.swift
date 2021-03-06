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
import Fusuma

private enum SelectImageState {
    case Logo
    case Front
    case Back
    case None
}

final class AddCardViewController: UIViewController {
    
    private let viewModel = AddCardViewModel()
    
    private var selectImageState: SelectImageState = .None
    
    private var name: String? {
        guard let text = titleTextField.text where !text.isEmpty else {
            return nil
        }
        return titleTextField.text
    }
    
    private var icon: UIImage? {
        if logoImageView.image == Icon.cardPlaceholderIcon { return nil }
        return logoImageView.image
    }
    
    private var barcode: String? {
        guard let text = barcodeTextField.text where !text.isEmpty else {
            return nil
        }
        return barcodeTextField.text
    }
    
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
    
    private lazy var logoImageView: LogoImageView = {
        return LogoImageView(frame: .zero).then {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLogoImage)))
        }
    }()

    private lazy var titleTextField: UITextField = {
        return UITextField().then {
            $0.tag = 1
            let attributes = [
                NSForegroundColorAttributeName: UIColor.mountainMistColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(17)
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "Ввести название карты...", attributes:attributes)
        }
    }()
    
    private lazy var barcodeTextField: PaddingTextField = {
        return PaddingTextField(verticalPadding: 8, horizontalPadding: 10).then {
            $0.layer.cornerRadius = 6
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
    
    private lazy var frontSelectView: SelectCardView = {
        return SelectCardView(frame: .zero).then {
            $0.setUpWithPlaceholderImage(Icon.frontPlaceholderIcon, placeholderText: "Лицевая часть карты")
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectFrontImage)))
        }
    }()
    
    private lazy var backSelectView: SelectCardView = {
        return SelectCardView(frame: .zero).then {
            $0.setUpWithPlaceholderImage(Icon.backPlaceholderIcon, placeholderText: "Обратная часть карты")
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectBackImage)))
        }
    }()
    
    private lazy var barcodeView: BarcodeView = BarcodeView()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
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
        [logoWrapper, barcodeTextField, frontSelectView, backSelectView, barcodeView]
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
        
        constrain(frontSelectView, backSelectView, barcodeView, barcodeTextField, view) {
            frontSelectView, backSelectView, barcodeView, barcodeTextField, view in
            frontSelectView.top == barcodeTextField.bottom + 20
            frontSelectView.leading == view.leading + 20
            frontSelectView.width == (UIScreen.mainScreen().bounds.width - 60) / 2
            frontSelectView.height == frontSelectView.width * (100 / 158)
            
            backSelectView.top == frontSelectView.top
            backSelectView.trailing == view.trailing - 20
            backSelectView.width == frontSelectView.width
            backSelectView.height == frontSelectView.height
            
            barcodeView.top == frontSelectView.bottom + 20
            barcodeView.leading == view.leading + 20
            barcodeView.trailing == view.trailing - 20
        }
    }
    
    // MARK: User Interaction
    
    private func presentFusumaViewController() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusumaTintColor = .appColor()
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    @objc private func selectLogoImage() {
        selectImageState = .Logo
        presentFusumaViewController()
    }
    
    @objc private func selectFrontImage() {
        selectImageState = .Front
        presentFusumaViewController()
    }
    
    @objc private func selectBackImage() {
        selectImageState = .Back
        presentFusumaViewController()
    }
    
    @objc private func saveCard() {
        if name == nil || barcode == nil {
            Drop.down("Название и номер карты не могут быть пустыми", state: .Error)
            return
        }
        dispatch { self.navigationController?.popToRootViewControllerAnimated(true) }
        viewModel.createCardWithName(name, icon: icon, barcode: barcode, frontIcon: frontSelectView.imageView.image,
                                     backIcon: backSelectView.imageView.image) { errorMessage in
                                        dispatch {
                                            if let errorMessage = errorMessage {
                                                Drop.down(errorMessage, state: .Error)
                                            }
                                        }
        }
    }
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @objc private func generateBarcodeImage(sender: UITextField) {
        barcodeView.setUpWithBarcode(sender.text)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: FusumaDelegate

extension AddCardViewController: FusumaDelegate {
    
    func fusumaImageSelected(image: UIImage) {
        switch selectImageState {
        case .Logo: logoImageView.image = image
        case .Front: frontSelectView.imageView.image = image
        case .Back: backSelectView.imageView.image = image
        default: break
        }
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
    }
    
    func fusumaCameraRollUnauthorized() {
        Drop.down("Разрешите доступ к вашим фотографиям в настройках", state: .Error)
    }
    
}

// MARK: Set Up

extension AddCardViewController {
    
    func setUpWithBarcode(barcode: String?) {
        barcodeTextField.text = barcode
        generateBarcodeImage(barcodeTextField)
    }
    
}
