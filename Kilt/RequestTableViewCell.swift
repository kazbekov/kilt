//
//  RequestTableViewCell.swift
//  Kilt
//
//  Created by Dias Dosymbaev on 9/21/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

class RequestTableViewCell: UITableViewCell {

    lazy var emailTextField = UITextField().then {
        $0.keyboardType = .EmailAddress
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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        titleLabel.textColor = .blackColor()
//        titleLabel.text = nil
//        subtitleLabel.text = nil
//        iconImageView.image = nil
    }

    func setUpViews() {
        [emailTextField].forEach { contentView.addSubview($0)}
    }
    
    func setUpConstraints() {
        constrain(emailTextField, contentView) {emailTextField, contentView in
            emailTextField.leading == contentView.leading + 15
            emailTextField.trailing == contentView.trailing
            emailTextField.height == contentView.height
            emailTextField.centerY == contentView.centerY
        }
    }
}

extension RequestTableViewCell {

    func setUpWithTitle(placeholder: String?) {
        emailTextField.placeholder = placeholder
    }

}