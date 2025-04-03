//
//  TradeEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

struct TradeEntity {
    let name: String
    let buySell: String
    let transactionQuantity: Decimal
    let price: Int64
    let timestamp: Int64
}

extension TradeEntity {
    func toDTO() -> TradeDTO {
        return TradeDTO(
            name: name,
            buySell: buySell,
            transactionQuantity: transactionQuantity,
            price: price,
            timestamp: timestamp)
    }

    func toHoldingDTO() -> HoldingDTO {
        let symbolStartIndex = name.index(name.startIndex, offsetBy: 4)
        let symbol = String(name[symbolStartIndex...])
        return HoldingDTO(
            name: name,
            totalBuyPrice: price,
            transactionQuantity: transactionQuantity,
            symbol: symbol)
    }
}
