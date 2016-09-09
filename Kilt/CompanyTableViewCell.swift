//
//  CompanyTableViewCell.swift
//  Kilt
//
//  Created by Otel Danagul on 07.09.16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class CompanyTableViewCell: UITableViewCell {
    
    lazy var logoImageView = LogoImageView(frame: .zero)
    
    private lazy var titleLabel = UILabel().then {
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
        [logoImageView, titleLabel, arrowImageView].forEach { contentView.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(logoImageView, titleLabel, arrowImageView, contentView) {
            logoImageView, titleLabel, arrowImageView, contentView in
            logoImageView.leading == contentView.leading + 10
            logoImageView.centerY == contentView.centerY
            logoImageView.width == 55
            logoImageView.height == 55
            
            arrowImageView.trailing == contentView.trailing - 18
            arrowImageView.centerY == contentView.centerY
            arrowImageView.width == 6
            arrowImageView.height == 12
            
            titleLabel.leading == logoImageView.trailing + 15
            titleLabel.trailing == arrowImageView.leading - 15
            titleLabel.centerY == contentView.centerY
        }
    }
}

extension CompanyTableViewCell {
    func setUpWithTitle(title: String?) {
        titleLabel.text = title
    }
}
