//
//  TradeEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation
import NumberterKit
import RealmSwift

struct TradeEntity {
    let name: String
    let buySell: String
    let transactionQuantity: Decimal
    let price: Int64
    let timestamp: Int64

    var unitPrice: Decimal {
        guard transactionQuantity > 0 else { return 0 }
        return price.decimalValue / transactionQuantity
    }
}

extension TradeEntity {
    func toObject() -> TradeObject {
        let object = TradeObject()
        object.name = name

        return TradeObject(
            name: name,
            buySell: buySell,
            transactionQuantity: Decimal128(value: transactionQuantity),
            price: price,
            timestamp: timestamp)
    }

    func toHoldingEntity() -> HoldingEntity {
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

    func toHistoryEntity() -> TradeHistoryEntity {
        let type: TradeHistoryType = buySell.lowercased() == "buy" ? .buy : .sell
        let totalPrice = price.decimalValue / transactionQuantity

        let formattedPrice = price.currencyString(.won)
        let formattedAmount = transactionQuantity.formatted(fractionDigits: 6) + " " + FormatUtility.nameToSymbol(name)
        let formattedTotal = totalPrice.currencyString(.won)
        let formattedDate = String.convertTradeHistoryDate(timestamp: timestamp)

        return TradeHistoryEntity(
            type: type,
            market: name,
            price: formattedPrice,
            amount: formattedAmount,
            total: formattedTotal,
            date: formattedDate
        )
    }

}
