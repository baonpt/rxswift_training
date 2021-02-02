//
//  ViewController.swift
//  RxTraining
//
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import RxDataSources

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    var viewModel = ViewModel()
    var disposeBag = DisposeBag()
    var indexSelected: [Int: Int] = [:]
    var sections: [StyleSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeUI()
        tableViewDidLoad()
        binding()
    }
}

extension ViewController {
    
    func makeUI() {
        submitButton.corner()
    }
    
    func tableViewDidLoad() {
        tableView.register(CheckBoxCell.self)
        tableView.register(SectionHeaderCell.self)
        tableView.register(TextFieldCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func binding() {
        
        let input = ViewModel.Input(refresh: Driver.just(()))
        let output = viewModel.transform(input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<StyleSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .header(let cellViewModel):
                guard let cell = tableView.dequeue(SectionHeaderCell.self) else { return UITableViewCell() }
                
                return cell.then {
                    $0.bind(to: cellViewModel)
                }
            case .checkBox(let cellViewModel):
                guard let cell = tableView.dequeue(CheckBoxCell.self) else { return UITableViewCell() }
                
                return cell.then {
                    $0.bind(to: cellViewModel)
                }
            case .textField(let cellViewModel):
                guard let cell = tableView.dequeue(TextFieldCell.self) else { return UITableViewCell() }
                
                let textDidChange = PublishSubject<String>()
                cellViewModel.bind(to: textDidChange.asDriver(onErrorJustReturn: ""))
                
                return cell.then {
                    $0.bind(to: cellViewModel, textDidChange: textDidChange)
                }
            }
        })
        
        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath: indexPath, section: dataSource[indexPath.section])
            }
            .subscribe(onNext: { [unowned self] source in
                let indexPath = source.indexPath
                let rowIndex = indexPath.row
                let sectionIndex = indexPath.section
                
                let didSelectCell = { (index: Int, isSelected: Bool) in
                    let _indexPath = IndexPath(row: index, section: sectionIndex)
                    let item = source.section.items[index]
                    
                    guard let cell = self.tableView.cellForIndexPath(CheckBoxCell.self, at: _indexPath) else { return }
                    switch item {
                    case .checkBox(let cellViewModel):
                        cellViewModel.bind(isSelected)
                        cell.bind(to: cellViewModel)
                    default: break
                    }
                }
                
                if let currentIndexSelected = self.indexSelected[sectionIndex] {
                    didSelectCell(currentIndexSelected, false)
                }
                
                didSelectCell(rowIndex, true)
                
                self.indexSelected[sectionIndex] = rowIndex
            })
            .disposed(by: disposeBag)
        
        output.sections
            .filter({ !$0.isEmpty })
            .do(onNext: { [unowned self]sections in
                self.sections = sections
            })
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.sections[indexPath.section]
        let item = section.items[indexPath.row]
        
        switch item {
        case .header:
            return 100
        case .textField:
            return 75
        default:
            return 44
        }
    }
}
