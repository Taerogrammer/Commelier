//
//  HoldingDTO.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation
import RealmSwift

struct HoldingDTO {
    let name: String
    let totalBuyPrice: Int64
    let transactionQuantity: Decimal
    let symbol: String
}

extension HoldingDTO {
    func toHoldingMarketEntity() -> HoldingMarketEntity {
        return HoldingMarketEntity(
            symbol: symbol,
            totalBuyPrice: totalBuyPrice)
    }

    func toObject() -> HoldingObject {
        let object = HoldingObject()
        object.name = name
        object.totalBuyPrice = totalBuyPrice
        object.transactionQuantity = Decimal128(value: transactionQuantity)
        object.symbol = symbol

        return object
    }
}

extension HoldingDTO {
    /// 평균 매입 단가
    var averageBuyPrice: Int64 {
        guard transactionQuantity > 0 else { return 0 }
        return Decimal.toInt64(Int64.toDecimal(totalBuyPrice) / transactionQuantity)
    }

    // TODO: - entity 분리
    // TODO: - 컴포넌트 분리
    /// 평가손익 계산: (현재가 * 보유수량) - 총 매수금액
    func profitAmount(currentPrice: Decimal) -> Decimal {
        let marketValue = currentPrice * transactionQuantity
        return marketValue - Int64.toDecimal(totalBuyPrice)
    }

    /// 수익률 계산: ((평가손익 / 총 매수금액) * 100)
    func profitRatio(currentPrice: Decimal) -> Decimal {
        let profit = profitAmount(currentPrice: currentPrice)
        let total = Int64.toDecimal(totalBuyPrice)
        guard total > 0 else { return 0 }
        return (profit / total * 100).rounded(scale: 2, mode: .plain)
    }
}
