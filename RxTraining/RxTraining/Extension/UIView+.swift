//
//  UIView+.swift
//  RxTraining
//
//  Created by Nguyễn Phạm Thiên Bảo on 1/29/21.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var borderWidth : CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var isMask : Bool {
        set {
            self.layer.masksToBounds = newValue
        }
        
        get {
            return layer.masksToBounds
        }
    }
    
    public var width: CGFloat {
        get { return self.frame.width }
        set { self.frame.size.width = newValue }
    }
    
    public var height: CGFloat {
        get { return self.frame.height }
        set { self.frame.size.height = newValue }
    }
    
    public func corner(_ radius: CGFloat? = nil) {
        self.layoutIfNeeded()
        self.layer.cornerRadius = radius ?? self.width > self.height ? self.height/2 : self.width/2
        self.layer.masksToBounds = true
    }
}
