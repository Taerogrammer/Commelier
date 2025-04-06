//
//  PriceChangeEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import UIKit

// MARK: - 위치 고민해보기
enum PriceChangeState: String, Decodable {
    case rise = "RISE"
    case fall = "FALL"
    case even = "EVEN"

    var color: UIColor {
        switch self {
        case .rise: return SystemColor.red
        case .fall: return SystemColor.green
        case .even: return SystemColor.gray
        }
    }

    var symbol: String {
        switch self {
        case .rise: return "▲"
        case .fall: return "▼"
        case .even: return ""
        }
    }

    var description: String {
        switch self {
        case .rise: return "상승"
        case .fall: return "하락"
        case .even: return "보합"
        }
    }
}
