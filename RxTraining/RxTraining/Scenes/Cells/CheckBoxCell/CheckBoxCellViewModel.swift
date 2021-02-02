//
//  CheckBoxCellViewModel.swift
//  RxTraining
//
//

import Foundation
import RxCocoa
import RxSwift

class CheckBoxCellViewModel {
    
    var name: Driver<String>
    var imageURL: Driver<String>
    var isSelected: Driver<Bool>
    
    // Init with model is style
    init(with model: Style) {
        self.name = Driver.just(model.name ?? "")
        self.imageURL = Driver.just(model.imageURL ?? "")
        self.isSelected = Driver.just(false)
    }
    
    func bind(_ isSelected: Bool) {
        self.isSelected = Driver.just(isSelected)
    }
}
