//
//  Constants.swift
//  RxTraining
//
//

import Foundation
import UIKit
import Then

typealias JSON = [String: Any]
typealias Hex = Constants.Hex

struct Constants {
    
    enum Hex: String {
        case hexD1F2EB = "D1F2EB"
        case hex1ABC9C = "1ABC9C"
        
        var toString: String {
            return self.rawValue
        }
        
        var toColor: UIColor {
            return UIColor(hex: self.toString)
        }
    }
}

// Define title of group
enum Group: String, CaseIterable {
    case SUIT_STYLE = "KIỂU CHÍNH - SUIT STYLE"
    case FIT_STYLE = "KIỂU THÂN - FIT STYLE"
    case BACK_STYLE = "KIỂU XẺ TÀ SAU - BACK STYLE"
    case SLEEVE_BUTTON = "NÚT TAY ÁO -SLEEVE BUTTON"
    case SUIT_LAPELS = "KIỂU VE ÁO - SUIT LAPELS"
    case LAPEL_WIDTH = "ĐỘ RỘNG VE ÁO - LAPEL WIDTH"
    case POCKET_STYLE = "KIỂU TÚI ÁO DƯỚI - POCKET STYLE"
    case BREAST_POCKET = "KIỂU TÚI ÁO TRÊN - BREAST POCKET"
    case PANT_STYLE = "KIỂU QUẦN - PANT STYLE"
    case PANT_PLEAT = "XẾP LY TRƯỚC - PANT PLEAT"
    case PANT_CUFFS = "KIỂU ỐNG QUẦN - PANT CUFFS"
    case PANT_FASTENING = "NÚT CÀI GIỮA - PANTS FASTENING"
    case PANT_POCKETS = "KIỂU TÚI QUẦN BÊN - PANT POCKETS"
    case PANT_BACK_POCKET = "KIỂU TÚI QUẦN SAU - PANT BACK POCKET"
    
    static func of(_ number: Int) -> Group {
        let index = number-1
        guard index < Group.allCases.count else { return .SUIT_STYLE }
        return Group.allCases[index]
    }
}

// Define measurement
enum Measurement: String, CaseIterable {
    case neck = "Neck measurement - Số đo vòng cổ"
    case shoulder = "Full shoulder width measurement - Số đo vai"
    case armpit = "Armpit circle measurement - Số đo nách"
}
