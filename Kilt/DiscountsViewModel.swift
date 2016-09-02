//
//  DiscountsViewModel.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class DiscountsViewModel {
    var discounts = [Discount]()
    func fetchDiscounts(completion: ()-> Void) {
        Discount.fetchDiscounts { (snapshot) in
            self.discounts.append(Discount(snapshot: snapshot, childChanged: completion))
            completion()
        }
    }
}
