//
//  TableView+.swift
//  RxTraining
//
//

import Foundation
import UIKit

extension UITableView {
    enum IndexPathType {
        case row
        case section
    }
    
    public var cells: [UITableViewCell] {
        (0..<self.numberOfSections).indices.map { (sectionIndex: Int) -> [UITableViewCell] in
            (0..<self.numberOfRows(inSection: sectionIndex)).indices.compactMap { (rowIndex: Int) -> UITableViewCell? in
                self.cellForRow(at: IndexPath(row: rowIndex, section: sectionIndex))
            }
        }.flatMap { $0 }
    }
    
    func allCells<T: UITableViewCell>(_ indexType: IndexPathType, for cellType: T.Type) -> [T] {
        let numberOfCells = indexType == .row ? self.numberOfRows(inSection: 0) : self.numberOfSections
        
        var cells = [T]()
        
        (0..<numberOfCells).forEach({ index in
            let indexPath = IndexPath(row: indexType == .row ? index : 0, section: indexType == .row ? 0 : index)
            guard let cell = self.cellForRow(at: indexPath) as? T else { return }
            cells.append(cell)
        })
        
        return cells
    }
    
//    public func register<T: UITableViewCell>(_ aClass: T.Type, bundle: Bundle? = nil) {
//        let name = String(describing: aClass)
//        let nib = UINib(nibName: name, bundle: bundle)
//        register(nib, forCellReuseIdentifier: name)
//    }
    
    public func cellForIndexPath<T: UITableViewCell>(_ aClass: T.Type, at indexPath: IndexPath) -> T? {
        return self.cellForRow(at: indexPath) as? T
    }
    
    public func register<T: UITableViewCell>(_ aClass: T.Type) {
        register(aClass.nib, forCellReuseIdentifier: aClass.identifier)
    }
    
    public func register<T: UITableViewHeaderFooterView>(_ aClass: T.Type, bundle: Bundle? = nil) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    public func register<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forHeaderFooterViewReuseIdentifier: name)
    }
    
    public func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T? {
        let name = T.identifier
        return dequeueReusableCell(withIdentifier: name) as? T
    }
    
    public func dequeue<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T? {
        let name = String(describing: aClass)
        return dequeueReusableHeaderFooterView(withIdentifier: name) as? T
    }
    
    public func dequeue<T: UITableViewCell>(_ aClass: T.Type, for indexPath: IndexPath) -> T? {
        let name = String(describing: aClass)
        return dequeueReusableCell(withIdentifier: name, for: indexPath) as? T
    }
    
    public func configure(_ viewController: UIViewController) {
        self.delegate = viewController as? UITableViewDelegate
        self.dataSource = viewController as? UITableViewDataSource
    }
}
