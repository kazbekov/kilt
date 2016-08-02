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
    
    var name: String? {
        guard let text = nameTextField.text where !text.isEmpty else {
            return nil
        }
        return nameTextField.text
    }
    
    var address: String? {
        guard let text = locationTextField.text where !text.isEmpty else {
            return nil
        }
        return locationTextField.text
    }
    
    var icon: UIImage? {
        if avatarImageView.image == Icon.profilePlaceholderIcon { return nil }
        return avatarImageView.image
    }
    
    lazy var avatarImageView = UIImageView().then {
        $0.contentMode = .ScaleAspectFill
        $0.clipsToBounds = true
        $0.image = Icon.profilePlaceholderIcon
        $0.userInteractionEnabled = true
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
    
    private lazy var nameBottomLine = UIView().then {
        $0.backgroundColor = .mountainMistColor()
    }
    
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
    
    private lazy var locationBottomLine = UIView().then {
        $0.backgroundColor = .mountainMistColor()
    }
    
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
        userInteractionEnabled = false
        updateBottomLines()
        [avatarImageView, nameTextField, locationTextField, nameBottomLine, locationBottomLine].forEach { addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(avatarImageView, nameTextField, locationTextField, self) {
            avatarImageView, nameTextField, locationTextField, view in
            avatarImageView.top == view.top + 17
            avatarImageView.centerX == view.centerX
            avatarImageView.width == 60
            avatarImageView.height == 60
            
            nameTextField.top == avatarImageView.bottom + 8
            nameTextField.leading == view.leading + 20
            nameTextField.trailing == view.trailing - 20
            nameTextField.height == 30
            
            locationTextField.top == nameTextField.bottom + 2
            locationTextField.leading == nameTextField.leading
            locationTextField.trailing == nameTextField.trailing
            locationTextField.height == 30
        }
        
        constrain(nameTextField, locationTextField, nameBottomLine, locationBottomLine) {
            nameTextField, locationTextField, nameBottomLine, locationBottomLine in
            nameBottomLine.top == nameTextField.bottom
            nameBottomLine.leading == nameTextField.leading
            nameBottomLine.trailing == nameTextField.trailing
            nameBottomLine.height == 1
            
            locationBottomLine.top == locationTextField.bottom
            locationBottomLine.leading == locationTextField.leading
            locationBottomLine.trailing == locationTextField.trailing
            locationBottomLine.height == 1
        }
    }
    
    private func updateBottomLines() {
        nameBottomLine.hidden = !userInteractionEnabled
        locationBottomLine.hidden = !userInteractionEnabled
    }
    
}

extension ProfileTableHeaderView {
    
    func toggleInteraction() {
        userInteractionEnabled = !userInteractionEnabled
        updateBottomLines()
    }
    
    func setUpWithAvatar(name: String?, location: String?) {
        nameTextField.text = name
        locationTextField.text = location
    }
    
}
