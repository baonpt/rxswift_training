//
//  ViewModel.swift
//  RxTraining
//
//  Created by Nguyễn Phạm Thiên Bảo on 1/27/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

struct ViewModel {
    var disposeBag = DisposeBag()
    
    struct Input {
        var textFields: [Observable<String>]
    }
    
    struct Output {
        var loginButtonEnabled: Driver<Bool>
    }
    
    
    func transform(_ input: Input) -> Output {
        let textFieldsIsValid = input.textFields.map { textFieldObservable in
            textFieldObservable.map { !$0.isEmpty && $0.count <= 20 }
        }
        
        let loginButtonEnabled = Observable.combineLatest(textFieldsIsValid) { resut in
            return resut.reduce(true, { return $0 && $1 })
        }.asDriver(onErrorJustReturn: false)
        
        return Output(loginButtonEnabled: loginButtonEnabled)
    }
}
