//
//  HoldingObject.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Foundation
import RealmSwift

final class HoldingObject: Object {
    @Persisted(primaryKey: true) var name: String
    @Persisted var totalBuyPrice: Int64
    @Persisted var transactionQuantity: Decimal128
    @Persisted var symbol: String
    @Persisted var imageURL: String?

    var transactionPrice: Int64 {
        Decimal128.toInt64(transactionQuantity) * totalBuyPrice
    }
}

extension HoldingObject {
    func toEntity() -> HoldingEntity {
        return HoldingEntity(
            name: name,
            totalBuyPrice: totalBuyPrice,
            transactionQuantity: transactionQuantity.decimalValue,
            symbol: symbol,
            imageURL: imageURL)
    }

    func toWidgetModel() -> WidgetHoldingEntity {
        return WidgetHoldingEntity(symbol: symbol, amount: transactionQuantity.decimalValue)
    }
}
