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
    @Persisted var totalBuyPrice: Decimal128
    @Persisted var transactionQuantity: Decimal128
    @Persisted var symbol: String

    var transactionPrice: Decimal128 {
        transactionQuantity * totalBuyPrice
    }
}
