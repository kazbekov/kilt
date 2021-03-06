//
//  ContactInfoView.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/26/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

protocol ContactInfoViewDelegate {
    func makeCall(sender: UIButton)
}

final class ContactInfoView: UIView {
    
    var delegate: ContactInfoViewDelegate?
    
    private lazy var avatarImageView = UIImageView().then {
        $0.backgroundColor = .tundoraColor()
        $0.contentMode = .ScaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .Left
        $0.textColor = .tundoraColor()
        $0.font = .systemFontOfSize(12, weight: UIFontWeightMedium)
        $0.text = "Контактное лицо"
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.textAlignment = .Left
        $0.textColor = .blackColor()
        $0.font = .boldSystemFontOfSize(15)
    }
    
    private lazy var callButton: UIButton = {
        return UIButton().then {
            $0.addTarget(self, action: #selector(didPressCallButton(_:)), forControlEvents: .TouchUpInside)
            $0.backgroundColor = .fruitSaladColor()
            $0.titleLabel?.font = .systemFontOfSize(15, weight: UIFontWeightMedium)
            $0.setImage(Icon.phoneIcon, forState: .Normal)
            $0.setImage(Icon.phoneIcon, forState: .Highlighted)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -7, bottom: 0, right: 0)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        callButton.layer.cornerRadius = 4
    }
    
    private func setUpViews() {
        [avatarImageView, titleLabel, nameLabel, callButton].forEach {
            addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(avatarImageView, titleLabel, nameLabel, callButton, self) {
            avatarImageView, titleLabel, nameLabel, callButton, view in
            avatarImageView.top == view.top
            avatarImageView.leading == view.leading
            avatarImageView.width == 50
            avatarImageView.height == 50
            
            titleLabel.top == view.top
            titleLabel.leading == avatarImageView.trailing + 14
            titleLabel.trailing == view.trailing
            
            nameLabel.top == titleLabel.bottom + 5
            nameLabel.leading == titleLabel.leading
            nameLabel.trailing == titleLabel.trailing
            
            callButton.top == nameLabel.bottom + 8
            callButton.leading == nameLabel.leading
            callButton.width == 148
            callButton.height == 30
        }
    }
    
    @objc private func didPressCallButton(sender: UIButton) {
        delegate?.makeCall(sender)
    }
    
}

extension ContactInfoView {
    
    func setUpWithAvatar(avatar: UIImage?, ownerName: String?, phoneNumber: String?) {
        avatarImageView.image = avatar
        nameLabel.text = ownerName
        callButton.setTitle(phoneNumber, forState: .Normal)
    }
    
}
