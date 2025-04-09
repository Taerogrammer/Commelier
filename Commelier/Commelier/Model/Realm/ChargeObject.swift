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
    @Persisted var chargeAmount: Int64
    @Persisted var timestamp: Int64

    convenience init(chargeAmount: Int64, timestamp: Int64) {
        self.init()
        self.chargeAmount = chargeAmount
        self.timestamp = timestamp
    }
}

extension ChargeObject {
    func toEntity() -> ChargeEntity {
        return ChargeEntity(
            amount: chargeAmount,
            timestamp: timestamp)
    }
}
