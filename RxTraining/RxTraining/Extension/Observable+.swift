//
//  Observable+.swift
//  RxTraining
//
//

import Foundation
import RxSwift
import RxCocoa
import BEMCheckBox

// Extension for button
extension Reactive where Base: UIButton {
    public var isEnable: Binder<Bool> {
        return Binder(self.base) { button, _isEnabled in
            guard _isEnabled else {
                button.disable()
                return
            }
            button.enable()
        }
    }
}

// Extension for image
extension Reactive where Base: UIImageView {
    public var imageURL: Binder<String> {
        return Binder(self.base) { imageView, imageURL in
            guard !imageURL.isEmpty else { return }
            imageView.load(from: imageURL)
        }
    }
}

// Extension for BEMCheckBox
extension Reactive where Base: BEMCheckBox {
    public var isOn: Binder<Bool> {
        return Binder(self.base) { checkBox, isOn in
            checkBox.setOn(isOn)
        }
    }
}
