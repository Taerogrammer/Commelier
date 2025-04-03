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
}
