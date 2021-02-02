//
//  UIColor+.swift
//  RxTraining
//
//  Created by Nguyễn Phạm Thiên Bảo on 1/29/21.
//

import Foundation
import UIKit

extension UIColor {
 
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        //scanner.sc = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0x00FF00) >> 8
        let b = rgbValue & 0x0000FF
        
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: 1
        )
    }

}
