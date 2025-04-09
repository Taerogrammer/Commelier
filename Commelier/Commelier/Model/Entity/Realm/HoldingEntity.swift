//
//  HoldingEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
//

import Foundation
import RealmSwift

struct HoldingEntity {
    let name: String
    let totalBuyPrice: Int64
    let transactionQuantity: Decimal
    let symbol: String
    let imageURL: String?
}

extension HoldingEntity {
    func toObject() -> HoldingObject {
        let object = HoldingObject()
        object.name = name
        object.totalBuyPrice = totalBuyPrice
        object.transactionQuantity = Decimal128(value: transactionQuantity)
        object.symbol = symbol
        object.imageURL = imageURL

        return object
    }
    func toHoldingMarketEntity() -> HoldingMarketEntity {
        return HoldingMarketEntity(
            symbol: symbol,
            totalBuyPrice: totalBuyPrice)
    }
}
