//
//  CurrentAssetCalculator.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

/// 현재 보유 가상 현금
struct CurrentAssetCalculator {
    static func calculateAvailableKRW(
        charges: [ChargeDTO],
        trades: [TradeDTO]
    ) -> Decimal {
        let totalCharge = charges.reduce(0) { $0 + $1.amount }

        let totalBuy = trades
            .filter { $0.buySell.lowercased() == "buy" }
            .reduce(0) { $0 + $1.price }

        let totalSell = trades
            .filter { $0.buySell.lowercased() == "sell" }
            .reduce(0) { $0 + $1.price }

        return totalCharge - totalBuy + totalSell
    }
}
