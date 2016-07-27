//
//  UIColor+Tints.swift
//  Kilt
//
//  Created by Nurdaulet Bolatov on 7/25/16.
//  Copyright © 2016 Nurdaulet Bolatov. All rights reserved.
//

import UIKit

extension UIColor {
    public static func colorFromHexCode(hex: String) -> UIColor! {
        var colorString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            .uppercaseString
        
        if colorString.hasPrefix("#") {
            colorString = colorString.fui_substringFromIndex(1)
        }
        
        let stringLength = colorString.characters.count
        if stringLength != 6 && stringLength != 8 {
            return nil
        }
        
        let rString = colorString.fui_substringToIndex(2)
        let gString = colorString.fui_substringFromIndex(2).fui_substringToIndex(2)
        let bString = colorString.fui_substringFromIndex(4).fui_substringToIndex(2)
        var aString: String?
        if stringLength == 8 { aString = colorString.fui_substringFromIndex(6).fui_substringToIndex(2) }
        
        var r: CUnsignedInt = 0
        var g: CUnsignedInt = 0
        var b: CUnsignedInt = 0
        var a: CUnsignedInt = 1
        
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        if let aString = aString {
            NSScanner(string: aString).scanHexInt(&a)
        }
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        let alpha = CGFloat(a) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private static func alphaHEX(alpha: CGFloat) -> String {
        if alpha <= 1 {
            return String(Int(alpha * 255), radix: 16, uppercase: true)
        }
        return "FF"
    }
    
    public static func colorFromHexCodeWithAlpha(hex: String, alpha: CGFloat) -> UIColor! {
        return self.colorFromHexCode(hex + alphaHEX(alpha))
    }
    
    public static func appColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.colorFromHexCode(ColorCodes.app + alphaHEX(alpha))
    }
    
    public static func tundoraColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.colorFromHexCode(ColorCodes.tundora + alphaHEX(alpha))
    }
    
    public static func fruitSaladColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.colorFromHexCode(ColorCodes.fruitSalad + alphaHEX(alpha))
    }
    
    public static func athensGrayColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.colorFromHexCode(ColorCodes.athensGray + alphaHEX(alpha))
    }
    
    public static func mountainMistColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.colorFromHexCode(ColorCodes.mountainMist + alphaHEX(alpha))
    }
    
    public static func frenchGrayColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.colorFromHexCode(ColorCodes.frenchGray + alphaHEX(alpha))
    }
    
    public static func crimsonColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.colorFromHexCode(ColorCodes.crimson + alphaHEX(alpha))
    }
    
    public struct ColorCodes {
        public static let app = "0198D7"
        public static let tundora = "4A4A4A"
        public static let fruitSalad = "4FA85D"
        public static let athensGray = "EFEFF4"
        public static let mountainMist = "8F8E94"
        public static let frenchGray = "C8C7CC"
        public static let crimson = "E01424"
    }
}

private extension String {
    func fui_substringFromIndex(index: Int) -> String {
        let newStart = startIndex.advancedBy(index)
        return self[newStart ..< endIndex]
    }
    
    func fui_substringToIndex(index: Int) -> String {
        let newEnd = startIndex.advancedBy(index)
        return self[startIndex ..< newEnd]
    }
}
