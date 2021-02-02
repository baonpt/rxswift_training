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
import RxDataSources

// Define sections
enum StyleSection {
    case style(number: Int, items: [StyleItem])
}

enum StyleItem {
    case header(viewModel: SectionHeaderCellViewModel)
    case checkBox(viewModel: CheckBoxCellViewModel)
    case textField(viewModel: TextFieldCellViewModel)
}

extension StyleSection: SectionModelType {
    typealias Item = StyleItem
    
    var number: Int {
        switch self {
        case .style(let number, _): return number
        }
    }
    
    var items: [Item] {
        switch self {
        case .style(_, let items): return items.map {$0}
        }
    }
    
    init(original: StyleSection, items: [StyleItem]) {
        switch original {
        case .style(let number, let items):
            self = .style(number: number, items: items)
        }
    }
}

struct ViewModel {
    var disposeBag = DisposeBag()
    
    struct Input {
        var refresh: Driver<Void>
    }
    
    struct Output {
        var sections: Driver<[StyleSection]>
        var rowHeight: Driver<CGFloat>
    }
    
    func transform(_ input: Input) -> Output {
        
        let sectionSubject = BehaviorRelay<[StyleSection]>(value: [])
        
        input.refresh
            .asObservable()
            .flatMapLatest { () -> Observable<JSON?> in
                return APIRequest.allStyles()
            }
            .subscribe(onNext: { json in
                guard let json = json
                else {
                    sectionSubject.accept([])
                    return
                }
                var sections = [StyleSection]()
                
                // Init data for check box
                json.forEach { dataJSON in
                    guard let jsonOfStyle = dataJSON.value as? [JSON] else { return }
                    
                    let numberOfCheckBoxSection = Int(dataJSON.key) ?? 0
                    let headerCheckBoxSectionViewModel = SectionHeaderCellViewModel(with: numberOfCheckBoxSection)
                    let headerCheckBoxSection = StyleItem.header(viewModel: headerCheckBoxSectionViewModel)
                    
                    var checkBoxSectionItems = jsonOfStyle.compactMap { Style(JSON: $0) }
                        .map { StyleItem.checkBox(viewModel: CheckBoxCellViewModel(with: $0)) }
                    checkBoxSectionItems.insert(headerCheckBoxSection, at: 0)
                    let checkBoxSection = StyleSection.style(number: Int(dataJSON.key) ?? 0,
                                                             items: checkBoxSectionItems)
                    
                    sections.append(checkBoxSection)
                }
                
                // Init data for text field
                let allMeasurement = Measurement.allCases
                let numberOfTextFieldSection = json.count + 1
                let headerTextFieldSectionViewModel = SectionHeaderCellViewModel(number: numberOfTextFieldSection,
                                                                                 title: "MERASUREMENT",
                                                                                 description: "Số đo")
                let headerTextField = StyleItem.header(viewModel: headerTextFieldSectionViewModel)
                var textFieldSectionItems = allMeasurement
                    .map { StyleItem.textField(viewModel: TextFieldCellViewModel(with: $0.rawValue)) }
                textFieldSectionItems.insert(headerTextField, at: 0)
                let textFieldSection = StyleSection.style(number: numberOfTextFieldSection,
                                                          items: textFieldSectionItems)
                sections.append(textFieldSection)
                
                sections = sections.sorted(by: { $0.number < $1.number })
                sectionSubject.accept(sections)
                
            }, onError: { error in
                
            })
            .disposed(by: disposeBag)
        
        return Output(sections: sectionSubject.asDriver(),
                      rowHeight: Driver.just(50))
    }
}
