//
//  CardsTableViewCell.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class CardsTableViewCell: UITableViewCell {
    
    private lazy var cardLogoImageView = CardLogoImageView(frame: .zero)
    
    private lazy var cardTitleLabel = UILabel().then {
        $0.textColor = .tundoraColor()
        $0.font = .systemFontOfSize(18)
    }
    
    private lazy var arrowImageView = UIImageView().then {
        $0.contentMode = .ScaleAspectFit
        $0.image = Icon.rightArrowIcon
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        selectionStyle = .None
        separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        layoutMargins = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        [cardLogoImageView, cardTitleLabel, arrowImageView].forEach { contentView.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(cardLogoImageView, cardTitleLabel, arrowImageView, contentView) {
            cardLogoImageView, cardTitleLabel, arrowImageView, contentView in
            cardLogoImageView.leading == contentView.leading + 10
            cardLogoImageView.centerY == contentView.centerY
            cardLogoImageView.width == 55
            cardLogoImageView.height == 55
            
            arrowImageView.trailing == contentView.trailing - 18
            arrowImageView.centerY == contentView.centerY
            arrowImageView.width == 6
            arrowImageView.height == 12
            
            cardTitleLabel.leading == cardLogoImageView.trailing + 15
            cardTitleLabel.trailing == arrowImageView.leading - 15
            cardTitleLabel.centerY == contentView.centerY
        }
    }
    
}

extension CardsTableViewCell {
    func setUpWithCard(title: String?) {
        cardLogoImageView.setUpWithTitle(title)
        cardTitleLabel.text = title
    }
}
