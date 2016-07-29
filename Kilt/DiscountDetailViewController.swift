//
//  DiscountDetailViewController.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/29/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit
import Sugar
import Cartography

final class DiscountDetailViewController: UIViewController {
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: Icon.backIcon, style: UIBarButtonItemStyle.Plain,
                               target: self, action: #selector(popViewController))
    }()
    
    private lazy var negativeSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil).then {
        $0.width = -7
    }
    
    private lazy var logoImageView = LogoImageView(frame: .zero)
    
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .Left
        $0.textColor = .blackColor()
        $0.font = .systemFontOfSize(20, weight: UIFontWeightMedium)
    }
    
    private lazy var percentLabel = UILabel().then {
        $0.textAlignment = .Center
        $0.textColor = .appColor()
        $0.font = .systemFontOfSize(30, weight: UIFontWeightSemibold)
    }
    
    private lazy var subtitleLabel = UILabel().then {
        $0.textAlignment = .Left
        $0.numberOfLines = 3
        $0.textColor = .blackColor()
        $0.font = .systemFontOfSize(15)
    }
    
    private lazy var addressTitleLabel = UILabel().then {
        $0.text = "Адрес магазина"
        $0.textAlignment = .Left
        $0.textColor = .mountainMistColor()
        $0.font = .systemFontOfSize(12)
    }
    
    private lazy var addressLabel = UILabel().then {
        $0.textAlignment = .Left
        $0.numberOfLines = 2
        $0.textColor = .blackColor()
        $0.font = .systemFontOfSize(15)
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: Set Up
    
    private func setUpViews() {
        edgesForExtendedLayout = .None
        view.backgroundColor = .whiteColor()
        navigationItem.title = "Карточки"
        navigationItem.leftBarButtonItems = [negativeSpace, leftBarButtonItem]
        [logoImageView, titleLabel, subtitleLabel, addressTitleLabel, addressLabel, percentLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        constrain(logoImageView, titleLabel, subtitleLabel, percentLabel, view) {
            logoImageView, titleLabel, subtitleLabel, percentLabel, view in
            logoImageView.top == view.top + 20
            logoImageView.leading == view.leading + 20
            logoImageView.width == 80
            logoImageView.height == 80
            
            titleLabel.top == logoImageView.top
            titleLabel.leading == logoImageView.trailing + 20
            titleLabel.trailing == view.trailing - 10
            
            subtitleLabel.top == titleLabel.bottom + 6
            subtitleLabel.leading == titleLabel.leading
            subtitleLabel.trailing == titleLabel.trailing
            
            percentLabel.top == logoImageView.bottom + 20
            percentLabel.centerX == logoImageView.centerX
        }
        constrain(subtitleLabel, addressTitleLabel, addressLabel) {
            subtitleLabel, addressTitleLabel, addressLabel in
            addressTitleLabel.top == subtitleLabel.bottom + 15
            addressTitleLabel.leading == subtitleLabel.leading
            addressTitleLabel.trailing == subtitleLabel.trailing
            
            addressLabel.top == addressTitleLabel.bottom + 2
            addressLabel.leading == addressTitleLabel.leading
            addressLabel.trailing == addressTitleLabel.trailing
        }
    }
    
    // MARK: User Interaction
    
    @objc private func popViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}

extension DiscountDetailViewController {
    
    func setUpWithDiscount(discount: Discount) {
        logoImageView.setUpWithTitle(discount.title)
        titleLabel.text = discount.title
        subtitleLabel.text = discount.subtitle
        percentLabel.text = discount.percent
        addressLabel.text = discount.address
    }
    
}
