//
//  DiscountsViewModel.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class DiscountsViewModel {
    var discounts = [
        Discount(title: "MEXX", percent: "15%", avatarImage: Icon.profileIcon,
            subtitle: "Работает вместе с дисконтной картой Mexx.", address: "г. Алматы, пр. Абылай-хана 45"),
        Discount(title: "MEXX", percent: "15%", avatarImage: Icon.profileIcon,
            subtitle: "Работает вместе с дисконтной картой Mexx.", address: "г. Алматы, пр. Абылай-хана 45"),
        Discount(title: "MEXX", percent: "15%", avatarImage: Icon.profileIcon,
            subtitle: "Работает вместе с дисконтной картой Mexx.", address: "г. Алматы, пр. Абылай-хана 45")
    ]
}
