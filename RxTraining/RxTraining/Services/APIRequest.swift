//
//  APIRequest.swift
//  RxTraining
//
//

import Foundation
import RxSwift
import Alamofire

class APIRequest {
    static func allStyles() -> Observable<JSON?> {
        Observable.create { observer in
            let url = "http://faifostore.tekup.vn/api/v1/styles"
            
            let task = Alamofire.request(url).responseJSON() { response in
                switch response.result {
                case .success:
                    guard response.isSuccess else {
                        observer.onNext(nil)
                        return
                    }
                    
                    guard let json = response.result.value as? JSON,
                          let data = json["data"] as? JSON,
                          let style = data["suit"] as? JSON
                    else {
                        observer.onNext(nil)
                        return
                    }
                    observer.onNext(style)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
