//
//  TradeType.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import UIKit

enum OrderType {
    case buy
    case sell

    var title: String {
        switch self {
        case .buy: return StringLiteral.Button.buy
        case .sell: return StringLiteral.Button.sell
        }
    }

    var priceTitle: String {
        switch self {
        case .buy: return StringLiteral.Trade.buyPrice
        case .sell: return StringLiteral.Trade.sellPrice
        }
    }

    var buttonColor: UIColor {
        switch self {
        case .buy: return SystemColor.red
        case .sell: return SystemColor.blue
        }
    }

    var holdingTitle: String {
        switch self {
        case .buy: return StringLiteral.Trade.holdingAsset
        case .sell: return StringLiteral.Trade.holdingQuantity
        }
    }

    var balanceTitle: String {
        switch self {
        case .buy: return StringLiteral.Trade.buyBalance
        case .sell: return StringLiteral.Trade.sellBalance
        }
    }

    var unit: String {
        return StringLiteral.Currency.krw
    }

    var coinUnit: String {
        return StringLiteral.Currency.tmpCoin
    }

    var inputPlaceholder: String {
        switch self {
        case .buy: return StringLiteral.Trade.buyPlaceholder
        case .sell: return StringLiteral.Trade.sellPlaceholder
        }
    }
}
