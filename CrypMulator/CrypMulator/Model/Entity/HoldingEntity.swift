//
//  HoldingEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
//

import Foundation

struct HoldingEntity {
    let name: String
    let totalBuyPrice: Int64
    let transactionQuantity: Decimal
    let symbol: String
    let imageURL: String?
}

extension HoldingEntity {
    func toDTO() -> HoldingDTO {
        return HoldingDTO(
            name: name,
            totalBuyPrice: totalBuyPrice,
            transactionQuantity: transactionQuantity,
            symbol: symbol,
            imageURL: imageURL)
    }
}
