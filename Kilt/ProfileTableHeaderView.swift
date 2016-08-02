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
    
    private lazy var nameTextField: UITextField = {
        return UITextField().then {
            $0.textAlignment = .Center
            $0.textColor = .blackColor()
            $0.font = .systemFontOfSize(17, weight: UIFontWeightMedium)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Center
            let placeholderAttributes = [
                NSForegroundColorAttributeName: UIColor.mountainMistColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(17, weight: UIFontWeightMedium),
                NSParagraphStyleAttributeName: paragraphStyle
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "Имя", attributes: placeholderAttributes)
            
        }
    }()
    
    private lazy var locationTextField: UITextField = {
        return UITextField().then {
            $0.textAlignment = .Center
            $0.textColor = .blackColor()
            $0.font = .systemFontOfSize(12, weight: UIFontWeightMedium)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Center
            let placeholderAttributes = [
                NSForegroundColorAttributeName: UIColor.mountainMistColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(12, weight: UIFontWeightMedium),
                NSParagraphStyleAttributeName: paragraphStyle
            ]
            $0.attributedPlaceholder = NSAttributedString(string: "Адрес", attributes: placeholderAttributes)
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
    
    private func setUpViews() {
        backgroundColor = .whiteColor()
        [avatarImageView, nameTextField, locationTextField].forEach { addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(avatarImageView, nameTextField, locationTextField, self) {
            avatarImageView, nameTextField, locationTextField, view in
            avatarImageView.top == view.top + 17
            avatarImageView.centerX == view.centerX
            avatarImageView.width == 60
            avatarImageView.height == 60
            
            nameTextField.top == avatarImageView.bottom + 8
            nameTextField.leading == view.leading
            nameTextField.trailing == view.trailing
            
            locationTextField.top == nameTextField.bottom + 6
            locationTextField.leading == view.leading
            locationTextField.trailing == view.trailing
        }
    }
    
}

extension ProfileTableHeaderView {
    
    func setUpWithAvatar(avatar: UIImage?, name: String?, location: String?) {
        avatarImageView.image = avatar
        nameTextField.text = name
        locationTextField.text = location
    }
    
}
