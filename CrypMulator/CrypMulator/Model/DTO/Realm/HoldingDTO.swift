//
//  HoldingDTO.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation
import RealmSwift

struct HoldingDTO {
    let name: String
    let totalBuyPrice: Int64
    let transactionQuantity: Decimal
    let symbol: String
}

extension HoldingDTO {
    func toHoldingMarketEntity() -> HoldingMarketEntity {
        return HoldingMarketEntity(
            symbol: symbol,
            totalBuyPrice: totalBuyPrice)
    }

    func toObject() -> HoldingObject {
        let object = HoldingObject()
        object.name = name
        object.totalBuyPrice = totalBuyPrice
        object.transactionQuantity = Decimal128(value: transactionQuantity)
        object.symbol = symbol

        return object
    }

    func toEntity() -> HoldingEntity {
        return HoldingEntity(
            name: name,
            totalBuyPrice: totalBuyPrice,
            transactionQuantity: transactionQuantity,
            symbol: symbol)
    }
}
