//
//  CurrentAssetCalculator.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation
import NumberterKit

/// 계산
struct Calculator {
    static func calculateAvailableKRW(
        charges: [ChargeEntity],
        trades: [TradeEntity]
    ) -> Int64 {
        let totalCharge = charges.reduce(0) { $0 + $1.amount }

        let totalBuy = trades
            .filter { $0.buySell.lowercased() == "buy" }
            .reduce(0) { $0 + $1.price }

        let totalSell = trades
            .filter { $0.buySell.lowercased() == "sell" }
            .reduce(0) { $0 + $1.price }

        return totalCharge - totalBuy + totalSell
    }

    /// 평가 손익 계산: (현재가 * 보유수량) - 총 매수금액
    static func profitAmount(transactionQuantity: Decimal, totalBuyPrice: Int64, currentPrice: Decimal) -> Decimal {
        let marketValue = currentPrice * transactionQuantity
        return marketValue - totalBuyPrice.decimalValue
    }

    /// 수익률 계산: ((평가손익 / 총 매수금액) * 100)
    static func profitRatio(transactionQuantity: Decimal, totalBuyPrice: Int64, currentPrice: Decimal) -> Decimal {
        let profit = profitAmount(transactionQuantity: transactionQuantity, totalBuyPrice: totalBuyPrice, currentPrice: currentPrice)
        let totalBuy = totalBuyPrice.decimalValue
        guard totalBuy > 0 else { return 0 }
        return (profit / totalBuy * 100).rounded(scale: 2, mode: .plain)
    }

    /// 평균 매입 단가
    static func averageBuyPrice(transactionQuantity: Decimal, totalBuyPrice: Int64) -> Int64 {
        guard transactionQuantity > 0 else { return 0 }
        return (totalBuyPrice.decimalValue / transactionQuantity).int64Value
    }
}
