//
//  DiscountsTableViewCell.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class DiscountsTableViewCell: UITableViewCell {
    
    private lazy var logoImageView = LogoImageView(frame: .zero)
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = .blackColor()
        $0.font = .systemFontOfSize(15, weight: UIFontWeightMedium)
    }
    
    private lazy var subtitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .mountainMistColor()
        $0.font = .systemFontOfSize(15)
    }
    
    private lazy var percentLabel = UILabel().then {
        $0.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        $0.textColor = .appColor()
        $0.font = .systemFontOfSize(17, weight: UIFontWeightSemibold)
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
        [logoImageView, titleLabel, subtitleLabel, percentLabel, arrowImageView].forEach { contentView.addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(logoImageView, titleLabel, percentLabel, arrowImageView, contentView) {
            logoImageView, titleLabel, percentLabel, arrowImageView, contentView in
            logoImageView.leading == contentView.leading + 10
            logoImageView.centerY == contentView.centerY
            logoImageView.width == 55
            logoImageView.height == 55
            
            arrowImageView.trailing == contentView.trailing - 18
            arrowImageView.centerY == contentView.centerY
            arrowImageView.width == 6
            arrowImageView.height == 12
            
            titleLabel.top == logoImageView.top
            titleLabel.leading == logoImageView.trailing + 15
            titleLabel.trailing == percentLabel.leading - 15
            
            percentLabel.top == titleLabel.top
            percentLabel.trailing == arrowImageView.leading - 10
        }
        constrain(titleLabel, subtitleLabel, percentLabel) {
            titleLabel, subtitleLabel, percentLabel in
            subtitleLabel.top == percentLabel.bottom
            subtitleLabel.leading == titleLabel.leading
            subtitleLabel.trailing == percentLabel.trailing
        }
    }
    
}

extension DiscountsTableViewCell {
    
    func setUpWithTitle(title: String?, subtitle: String?, percent: String?, logoImageUrl: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        percentLabel.text = percent
        logoImageView.contentMode = .ScaleAspectFill
        if let urlString = logoImageUrl, url = NSURL(string: urlString) {
            logoImageView.kf_setImageWithURL(url)
        }
    }
    
}
