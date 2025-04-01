//
//  Charge.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Foundation
import RealmSwift

final class ChargeObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var chargeAmount: Decimal128
    @Persisted var timestamp: Int64

    convenience init(chargeAmount: Decimal, timestamp: Int64) {
        self.init()
        self.chargeAmount = Decimal128(value: chargeAmount)
        self.timestamp = timestamp
    }
}
