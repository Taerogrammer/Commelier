//
//  Transaction.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Foundation
import RealmSwift

final class TradeObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var market: String
    @Persisted var buySell: String
    @Persisted var transactionQuantity: Decimal128
    @Persisted var price: Decimal128
    @Persisted var timestamp: Int64

    var transactionPrice: Decimal128 {
        price / transactionQuantity
    }
}

extension TradeObject {
    func toDTO() -> TradeDTO {
        return TradeDTO(
            market: market,
            buySell: buySell,
            transactionQuantity: transactionQuantity.decimalValue,
            price: price.decimalValue,
            timestamp: timestamp)
    }
}
