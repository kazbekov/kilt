//
//  MessageTableViewCell.swift
//  Kilt
//
//  Created by Dias Dosymbaev on 8/22/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class MessageTableViewCell: UITableViewCell {
    lazy var titleLabel = UILabel().then {
        $0.text = "Fidelity"
        $0.font = $0.font.fontWithSize(15)
    }
    private lazy var senderNameLabel = UILabel().then {
        $0.text = "Арман:"
        $0.font = $0.font.fontWithSize(15)
        $0.textColor = UIColor.tundoraColor()
    }
    private lazy var logoImageView = UIImageView().then {
        $0.image = Icon.placeholderIcon
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.frenchGrayColor().CGColor
    }
    private lazy var lastMessageLabel = UILabel().then {
        $0.text = "Мы очень благодарны за ваш совет"
        $0.font = $0.font.fontWithSize(15)
        $0.textColor = UIColor.mountainMistColor()
    }
    private lazy var timeStampLabel = UILabel().then {
        $0.text = "Вчера"
        $0.font = $0.font.fontWithSize(15)
        $0.textColor = UIColor.mountainMistColor()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [titleLabel, logoImageView, senderNameLabel, lastMessageLabel, timeStampLabel].forEach {
            contentView.addSubview($0)
        }
        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpConstraints() {
        constrain(titleLabel, logoImageView, contentView, senderNameLabel, lastMessageLabel) {titleLabel, logoImageView,contentView, senderNameLabel, lastMessageLabel in
            titleLabel.leading == logoImageView.trailing + 15
            titleLabel.top == contentView.top + 11

            senderNameLabel.top == titleLabel.bottom
            senderNameLabel.leading == logoImageView.trailing + 15

            lastMessageLabel.top == senderNameLabel.bottom
            lastMessageLabel.leading == logoImageView.trailing + 15

            logoImageView.leading == contentView.leading + 10
            logoImageView.top == contentView.top + 10
            logoImageView.bottom == contentView.bottom - 10
            logoImageView.width == 55
            logoImageView.height == 55
        }
        constrain(contentView, timeStampLabel, lastMessageLabel) {contentView, timeStampLabel, lastMessageLabel in
            timeStampLabel.top == contentView.top + 11
            timeStampLabel.trailing == lastMessageLabel.trailing
        }
    }
}