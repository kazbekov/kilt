//
//  BarcodeTextField.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/27/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

final class PaddingTextField: UITextField {
    
    private var verticalPadding: CGFloat = 0
    private var horizontalPadding: CGFloat = 0
    
    convenience init(verticalPadding: CGFloat, horizontalPadding: CGFloat) {
        self.init()
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + horizontalPadding, y: bounds.origin.y + verticalPadding,
                      width: bounds.size.width - horizontalPadding * 2, height: bounds.size.height - verticalPadding * 2)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.textRectForBounds(bounds)
    }
    
}
