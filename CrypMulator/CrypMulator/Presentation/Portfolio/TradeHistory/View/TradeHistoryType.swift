//
//  TradeHistoryType.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
//

import UIKit

enum TradeHistoryType {
    case buy
    case sell

    var text: String {
        switch self {
        case .buy: return StringLiteral.TradeHistory.buy
        case .sell: return StringLiteral.TradeHistory.sell
        }
    }

    var color: UIColor {
        switch self {
        case .buy: return SystemColor.red
        case .sell: return SystemColor.blue
        }
    }
}
