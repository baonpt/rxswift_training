//
//  Reuse.swift
//  RxTraining
//
//

import Foundation
import UIKit

protocol ReuseIdentifier {
  static var identifier: String { get }
}

extension ReuseIdentifier {
  static var identifier: String {
    return String(describing: Self.self)
  }
}

protocol ReuseNib: ReuseIdentifier {
  static var nib: UINib { get }
}

extension ReuseNib {
  static var nib: UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
}

extension UIViewController: ReuseIdentifier {}
extension UIView: ReuseNib {}
extension UITableViewCell: ReuseNib {}
extension UICollectionViewCell: ReuseNib {}
