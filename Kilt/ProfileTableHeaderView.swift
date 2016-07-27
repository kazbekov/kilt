//
//  ProfileTableHeaderView.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class ProfileTableHeaderView: UIView {
    
    private lazy var avatarImageView = UIImageView().then {
        $0.contentMode = .ScaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .blackColor()
        $0.font = .systemFontOfSize(17, weight: UIFontWeightMedium)
    }
    
    private lazy var locationLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .blackColor()
        $0.font = .systemFontOfSize(12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        backgroundColor = .whiteColor()
        [avatarImageView, nameLabel, locationLabel].forEach { addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(avatarImageView, nameLabel, locationLabel, self) {
            avatarImageView, nameLabel, locationLabel, view in
            avatarImageView.top == view.top + 17
            avatarImageView.centerX == view.centerX
            avatarImageView.width == 60
            avatarImageView.height == 60
            
            nameLabel.top == avatarImageView.bottom + 8
            nameLabel.centerX == view.centerX
            
            locationLabel.top == nameLabel.bottom + 6
            locationLabel.centerX == view.centerX
        }
    }
    
}

extension ProfileTableHeaderView {
    func setUpWithAvatar(avatar: UIImage?, name: String?, location: String?) {
        avatarImageView.image = avatar
        nameLabel.text = name
        locationLabel.text = location
    }
}
