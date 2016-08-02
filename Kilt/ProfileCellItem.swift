//
//  ProfileCellItem.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 8/2/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

struct ProfileCellItem {
    var title: String?
    var subtitle: String?
    var icon: UIImage?
    var titleColor: UIColor?
    
    init(title: String?, subtitle: String?, icon: UIImage?, titleColor: UIColor? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.titleColor = titleColor
    }
}
