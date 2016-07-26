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
    
    private lazy var cardImageView = UIImageView().then {
        $0.contentMode = .ScaleAspectFill
    }
    
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
        [cardImageView, cardTitleLabel, arrowImageView].forEach { contentView.addSubview($0) }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardImageView.layer.cornerRadius = 6
    }
    
    private func setUpConstraints() {
        constrain(cardImageView, cardTitleLabel, arrowImageView, contentView) {
            cardImageView, cardTitleLabel, arrowImageView, contentView in
            cardImageView.leading == contentView.leading + 10
            cardImageView.centerY == contentView.centerY
            cardImageView.width == 55
            cardImageView.height == 55
            
            arrowImageView.trailing == contentView.trailing - 18
            arrowImageView.centerY == contentView.centerY
            arrowImageView.width == 6
            arrowImageView.height == 12
            
            cardTitleLabel.leading == cardImageView.trailing + 15
            cardTitleLabel.trailing == arrowImageView.leading - 15
            cardTitleLabel.centerY == contentView.centerY
        }
    }
    
}
