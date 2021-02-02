//
//  Style.swift
//  RxTraining
//
//

import Foundation
import ObjectMapper

class Style: Mappable {
    
    var id: Int?
    var name: String?
    var imageURL: String?
    var group: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.imageURL <- map["thumbnail"]
        self.group <- map["group"]
    }
}
