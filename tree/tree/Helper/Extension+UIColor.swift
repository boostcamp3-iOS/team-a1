//
//  ColorExtension.swift
//  tree
//
//  Created by Hyeontae on 07/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(hexString: String) {
        let red, green, blue: CGFloat
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    blue = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                    
                    self.init(red: red, green: green, blue: blue, alpha: 1.0)
                    return 
                }
            }
        }
        self.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
