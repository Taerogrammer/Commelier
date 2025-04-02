//
//  ChargeEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

struct ChargeEntity {
    let amount: Decimal
    let timestamp: Int64
}

extension ChargeEntity {
    func toDTO() -> ChargeDTO {
        return ChargeDTO(amount: self.amount, timestamp: self.timestamp)
    }
}
