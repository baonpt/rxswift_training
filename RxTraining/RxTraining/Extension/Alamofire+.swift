//
//  Alamofire+.swift
//  RxTraining
//
//  Created by Nguyễn Phạm Thiên Bảo on 1/29/21.
//

import Foundation
import Alamofire

extension DataResponse {
    var statusCode: Int {
        if let res = self.response {
            return res.statusCode
        } else {
            return 404
        }
    }
    
    var isSuccess: Bool {
        return self.statusCode == 200
    }
}
