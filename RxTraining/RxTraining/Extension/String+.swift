//
//  String+.swift
//  RxTraining
//
//  Created by Nguyễn Phạm Thiên Bảo on 2/1/21.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
