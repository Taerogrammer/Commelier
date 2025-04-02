//
//  ChargeDTO.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

struct ChargeDTO {
    let amount: Decimal
    let timestamp: Int64
}

extension ChargeDTO {
    func toEntity() -> ChargeEntity {
        return ChargeEntity(amount: self.amount, timestamp: self.timestamp)
    }
}
