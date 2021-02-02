//
//  SectionHeaderCellViewModel.swift
//  RxTraining
//
//  Created by Nguyễn Phạm Thiên Bảo on 2/1/21.
//

import Foundation
import RxCocoa
import RxSwift

class SectionHeaderCellViewModel {
    
    // Properties
    var number: Driver<String>
    var title: Driver<String>
    var description: Driver<String>
    
    init(with number: Int) {
        let group = Group.of(number)
        let title = group.rawValue
        let titleComponents = title.components(separatedBy: "-").map { $0.trim() }
        
        self.number = Driver.just(String(number))
        self.title = Driver.just(titleComponents[1])
        self.description = Driver.just(titleComponents[0])
    }
    
    init(number: Int, title: String, description: String) {
        self.number = Driver.just(String(number))
        self.title = Driver.just(title)
        self.description = Driver.just(description)
    }
}
