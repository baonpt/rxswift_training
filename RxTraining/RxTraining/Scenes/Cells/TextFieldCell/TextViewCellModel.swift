//
//  TextViewCellModel.swift
//  RxTraining
//
//  Created by Nguyễn Phạm Thiên Bảo on 2/2/21.
//

import Foundation
import RxCocoa
import RxSwift

class TextFieldCellViewModel {
    
    var disposeBag = DisposeBag()
    
    var title: Driver<String>
    var text: Driver<String>
    
    init(with title: String) {
        self.title = Driver.just(title)
        self.text = Driver.just("")
    }
    
    func bind(to text: Driver<String>) {
        self.text = text
    }
}
