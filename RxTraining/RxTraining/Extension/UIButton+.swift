//
//  UIButton+.swift
//  RxTraining
//
//

import Foundation
import UIKit

extension UIButton {
    func enable() {
        self.isEnabled = true
        self.backgroundColor = .blue
        self.setTitleColor(.white, for: .normal)
    }
    
    func disable() {
        self.isEnabled = false
        self.backgroundColor = .lightGray
        self.setTitleColor(.gray, for: .normal)
    }
}
