//
//  CardLogoImageView.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/26/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class LogoImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 6
    }
    
    private func setUpViews() {
        clipsToBounds = true
        backgroundColor = .appColor()
        contentMode = .ScaleAspectFill
        userInteractionEnabled = true
        image = Icon.cardPlaceholderIcon
    }
    
}
