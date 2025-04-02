//
//  HoldingDTO.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

struct HoldingDTO {
    let name: String
    let totalBuyPrice: Decimal
    let transactionQuantity: Decimal
    let symbol: String
}

extension HoldingDTO {
    func toHoldingMarketEntity() -> HoldingMarketEntity {
        return HoldingMarketEntity(
            symbol: symbol,
            totalBuyPrice: totalBuyPrice)
    }
}
