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
    @Persisted var name: String
    @Persisted var buySell: String
    @Persisted var transactionQuantity: Decimal128
    @Persisted var price: Int64
    @Persisted var timestamp: Int64

    convenience init(name: String, buySell: String, transactionQuantity: Decimal128, price: Int64, timestamp: Int64) {
        self.init()
        self.name = name
        self.buySell = buySell
        self.transactionQuantity = transactionQuantity
        self.price = price
        self.timestamp = timestamp
    }

    var transactionPrice: Int64 {
        price / Decimal128.toInt64(transactionQuantity)
    }
}

extension TradeObject {
    func toDTO() -> TradeDTO {
        return TradeDTO(
            name: name,
            buySell: buySell,
            transactionQuantity: transactionQuantity.decimalValue,
            price: price,
            timestamp: timestamp)
    }
}
