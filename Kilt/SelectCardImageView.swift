//
//  SelectCardImageView.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class SelectCardImageView: UIImageView {
    
    private lazy var placeholderImageView = UIImageView().then {
        $0.contentMode = .Center
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 6
    }
    
    private func setUpViews() {
        backgroundColor = .whiteColor()
        contentMode = .ScaleAspectFill
        clipsToBounds = true
        layer.borderColor = UIColor.frenchGrayColor().CGColor
        layer.borderWidth = 1
        [placeholderImageView, placeholderLabel].forEach { addSubview($0) }
    }
    
    private func setUpConstraints() {
        constrain(placeholderImageView, placeholderLabel, self) {
            placeholderImageView, placeholderLabel, view in
            placeholderImageView.centerX == view.centerX
            placeholderImageView.centerY == view.centerY - 10
            
            placeholderLabel.top == placeholderImageView.bottom + 15
            placeholderLabel.centerX == view.centerX
        }
    }
    
}

extension SelectCardImageView {
    
    func setUpWithPlaceholderImage(placeholderImage: UIImage?, placeholderText: String?) {
        placeholderImageView.image = placeholderImage
        placeholderLabel.text = placeholderText
    }
    
    func setUpWithImage(image: UIImage?) {
        guard let image = image else { return }
        placeholderImageView.hidden = true
        placeholderLabel.hidden = true
        layer.borderWidth = 0
        self.image = image
    }
    
}
