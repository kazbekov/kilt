//
//  ProfileTableViewCell.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class ProfileTableViewCell: UITableViewCell {
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .Left
        $0.textColor = .blackColor()
        $0.font = .systemFontOfSize(15)
    }
    
    private lazy var subtitleLabel = UILabel().then {
        $0.textAlignment = .Right
        $0.textColor = .mountainMistColor()
        $0.font = .systemFontOfSize(15)
        $0.setContentHuggingPriority(1000, forAxis: .Horizontal)
    }
    
    private lazy var iconImageView = UIImageView().then {
        $0.contentMode = .ScaleAspectFill
        $0.clipsToBounds = true
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
        titleLabel.textColor = .blackColor()
        titleLabel.text = nil
        subtitleLabel.text = nil
        iconImageView.image = nil
    }
    
    private func setUpViews() {
        separatorInset = UIEdgeInsets(top: 0, left: 57, bottom: 0, right: 0)
        layoutMargins = UIEdgeInsets(top: 0, left: 57, bottom: 0, right: 0)
        [titleLabel, subtitleLabel, iconImageView].forEach { contentView.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, subtitleLabel, iconImageView, contentView) {
            titleLabel, subtitleLabel, iconImageView, contentView in
            iconImageView.leading == contentView.leading + 10
            iconImageView.centerY == contentView.centerY
            iconImageView.width == 32
            iconImageView.height == 32
            
            subtitleLabel.trailing == contentView.trailing - 15
            subtitleLabel.centerY == contentView.centerY
            
            titleLabel.leading == iconImageView.trailing + 15
            titleLabel.centerY == contentView.centerY
            titleLabel.trailing == subtitleLabel.leading - 10
        }
    }
    
}

extension ProfileTableViewCell {
    
    func setUpWithTitle(title: String?, subtitle: String?, icon: UIImage?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconImageView.image = icon
    }
    
    func setTitleLabelColor(color: UIColor) {
        titleLabel.textColor = color
    }
    
}
