//
//  DiscountDetailCollectionViewCell.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/29/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class DiscountDetailCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .ScaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setUpViews() {
        contentView.addSubview(imageView)
    }
    
    private func setUpConstraints() {
        constrain(imageView, contentView) {
            $0.edges == $1.edges
        }
    }
    
}

extension DiscountDetailCollectionViewCell {
    func setUpWithImage(image: UIImage?) {
        imageView.image = image
    }
}
