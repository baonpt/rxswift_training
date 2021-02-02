//
//  UIImageView+.swift
//  RxTraining
//
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func load(from url: String, cropTo size: CGSize? = nil, corner value: CGFloat? = nil) {
        guard let url = URL(string: url) else { return }
        if let size = size, let value = value {
            let processor = CroppingImageProcessor(size: size) |> RoundCornerImageProcessor(cornerRadius: value)
            kf.setImage(with: url, options: [.processor(processor)])
        } else {
            kf.setImage(with: url)
        }
    }
}
