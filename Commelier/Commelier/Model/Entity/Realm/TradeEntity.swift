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

    var unitPrice: Decimal {
        guard transactionQuantity > 0 else { return 0 }
        return Int64.toDecimal(price) / transactionQuantity
    }
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

    func toHoldingDTO() -> HoldingEntity {
        let symbolStartIndex = name.index(name.startIndex, offsetBy: 4)
        let symbol = String(name[symbolStartIndex...])
        let imageURL = ImageURLMapper.imageURL(for: name)
        return HoldingEntity(
            name: name,
            totalBuyPrice: price,
            transactionQuantity: transactionQuantity,
            symbol: symbol,
            imageURL: imageURL)
    }
}
