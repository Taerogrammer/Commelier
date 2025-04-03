//
//  TradeDTO.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

struct TradeDTO {
    let name: String
    let buySell: String
    let transactionQuantity: Decimal
    let price: Int64
    let timestamp: Int64
}

extension TradeDTO {
    func toEntity() -> TradeEntity {
        return TradeEntity(
            name: name,
            buySell: buySell,
            transactionQuantity: transactionQuantity,
            price: price,
            timestamp: timestamp)
    }

    func toHistoryEntity() -> TradeHistoryEntity {
        let type: TradeHistoryType = buySell.lowercased() == "buy" ? .buy : .sell
        let totalPrice = Decimal(price) / transactionQuantity

        let formattedPrice = FormatUtility.decimalToString(Decimal(price)) + StringLiteral.Currency.krw
        let formattedAmount = FormatUtility.decimalToString(transactionQuantity, fractionDigits: 6) + FormatUtility.nameToSymbol(name)
        let formattedTotal = FormatUtility.decimalToString(totalPrice) + StringLiteral.Currency.krw
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
