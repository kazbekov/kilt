//
//  CardLogoView.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/26/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class CardLogoView: UIView {
    
    private lazy var imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .tundoraColor()
        $0.contentMode = .ScaleAspectFill
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .whiteColor()
        $0.font = .boldSystemFontOfSize(20)
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
        imageView.layer.cornerRadius = 6
    }
    
    private func setUpViews() {
        [imageView, titleLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(imageView, titleLabel, self) {
            imageView, titleLabel, view in
            imageView.edges == view.edges
            titleLabel.center == view.center
        }
    }
    
}

extension CardLogoView {
    func setUpWithTitle(title: String?) {
        guard let title = title else { return }
        titleLabel.text = String(title.characters.prefix(1)).capitalizedString
    }
}
