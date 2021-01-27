//
//  Observable+.swift
//  RxTraining
//
//

import Foundation
import RxSwift
import RxCocoa

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
