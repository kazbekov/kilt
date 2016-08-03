//
//  SelectCardView.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class SelectCardView: UIView {
    
    lazy var imageView = UIImageView().then {
        $0.userInteractionEnabled = true
        $0.contentMode = .ScaleAspectFill
    }
    
    private lazy var placeholderImageView = UIImageView().then {
        $0.contentMode = .Center
    }
    
    private lazy var borderView = UIView().then {
        $0.layer.borderColor = UIColor.frenchGrayColor().CGColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 6
    }
    
    private lazy var placeholderLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .mountainMistColor()
        $0.font = .systemFontOfSize(10)
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
        clipsToBounds = true
        layer.cornerRadius = 6
        [borderView, placeholderImageView, placeholderLabel, imageView].forEach { addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(borderView, placeholderImageView, placeholderLabel, imageView, self) {
            borderView, placeholderImageView, placeholderLabel, imageView, view in
            borderView.edges == view.edges
            
            placeholderImageView.centerX == view.centerX
            placeholderImageView.centerY == view.centerY - 10
            
            placeholderLabel.top == placeholderImageView.bottom + 15
            placeholderLabel.centerX == view.centerX
            
            imageView.edges == view.edges
        }
    }
    
}

extension SelectCardView {
    
    func setUpWithPlaceholderImage(placeholderImage: UIImage?, placeholderText: String?) {
        placeholderImageView.image = placeholderImage
        placeholderLabel.text = placeholderText
    }
    
}
