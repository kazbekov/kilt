//
//  RequestTableHeaderView.swift
//  Kilt
//
//  Created by Dias Dosymbaev on 9/21/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography
import Fusuma

final class RequestTableHeaderView: UIView {

//    var name: String? {
//        get {
//            guard let text = nameTextField.text where !text.isEmpty else {
//                return nil
//            }
//            return nameTextField.text
//        }
//        set(name) {
//            dispatch { self.nameTextField.text = name }
//        }
//    }
//
//    var icon: UIImage? {
//        if avatarImageView.image == Icon.profilePlaceholderIcon { return nil }
//        return avatarImageView.image
//    }

    lazy var avatarImageView = UIImageView().then {
        $0.contentMode = .ScaleAspectFill
        $0.clipsToBounds = true
        $0.image = Icon.profilePlaceholderIcon
        $0.userInteractionEnabled = true
    }
    private lazy var companyNameLabel = UILabel().then {
        $0.text = "НАЗВАНИЕ"
        $0.font = $0.font.fontWithSize(12)
        $0.textAlignment = .Left
        $0.textColor = .riverBedColor()
    }
    lazy var nameTextField: UITextField = {
        return UITextField().then {
            $0.textAlignment = .Left
            $0.textColor = .blackColor()
            $0.font = .systemFontOfSize(15, weight: UIFontWeightRegular)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Left
            let placeholderAttributes = [
                NSForegroundColorAttributeName: UIColor.mountainMistColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(15, weight: UIFontWeightRegular),
                NSParagraphStyleAttributeName: paragraphStyle
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "Введите название компаний", attributes: placeholderAttributes)

        }
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }

    private func setUpViews() {
        backgroundColor = .whiteColor()
        userInteractionEnabled = true
        [avatarImageView, nameTextField, companyNameLabel].forEach { addSubview($0) }
        nameTextField.becomeFirstResponder()
    }

    private func setUpConstraints() {
        constrain(avatarImageView, nameTextField, companyNameLabel, self) {  avatarImageView, nameTextField, companyNameLabel, view in

            avatarImageView.centerY == view.centerY
            avatarImageView.leading == view.leading + 10
            avatarImageView.width == 70
            avatarImageView.height == 70

            companyNameLabel.leading == avatarImageView.trailing + 20
            companyNameLabel.top == avatarImageView.top + 5

            nameTextField.top == companyNameLabel.bottom + 5
            nameTextField.leading == companyNameLabel.leading
            nameTextField.trailing == view.trailing - 10
            nameTextField.height == 30
        }
    }
}

