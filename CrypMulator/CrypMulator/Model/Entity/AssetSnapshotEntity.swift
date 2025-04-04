//
//  AssetSnapshotEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
//

import Foundation

struct AssetSnapshotEntity {
    let totalAsset: Int64               // 총 자산 = 현금 + 코인 평가 금액 합계
    let totalCurrency: Int64            // 보유 현금
    let totalCoinValue: Int64           // 코인 평가금액 총합

    let holdingProfit: Decimal          // 평가 손익 총합
    let holdingYieldRate: Decimal       // 평가 수익률 평균

    let evaluatedCoins: [CoinEvaluationEntity] // 마켓별 평가 정보 (옵션)
}

struct CoinEvaluationEntity {
    let market: String
    let quantity: Decimal
    let currentPrice: Decimal
    let totalBuyPrice: Int64

    let marketValue: Decimal
    let profit: Decimal
    let profitRate: Decimal
}

struct AssetEvaluator {
    static func evaluate(
        from currentAsset: CurrentAssetEntity,
        currentPrices: [String: Decimal]
    ) -> AssetSnapshotEntity {
        var totalMarketValue: Decimal = 0
        var totalBuyValue: Decimal = 0
        var totalProfit: Decimal = 0

        var evaluatedCoins: [CoinEvaluationEntity] = []

        for holding in currentAsset.totalCoin {
            guard let currentPrice = currentPrices[holding.name] else { continue }

            let quantity = holding.transactionQuantity
            let buyPrice = holding.totalBuyPrice

            let marketValue = currentPrice * quantity
            let profit = Calculator.profitAmount(transactionQuantity: quantity, totalBuyPrice: buyPrice, currentPrice: currentPrice)
            let profitRate = Calculator.profitRatio(transactionQuantity: quantity, totalBuyPrice: buyPrice, currentPrice: currentPrice)

            evaluatedCoins.append(
                CoinEvaluationEntity(
                    market: holding.name,
                    quantity: quantity,
                    currentPrice: currentPrice,
                    totalBuyPrice: buyPrice,
                    marketValue: marketValue,
                    profit: profit,
                    profitRate: profitRate
                )
            )

            totalMarketValue += marketValue
            totalBuyValue += Int64.toDecimal(buyPrice)
            totalProfit += profit
        }

        let totalAssetDecimal = Decimal(currentAsset.totalCurrency) + totalMarketValue
        let yieldRate: Decimal = totalBuyValue > 0 ? (totalProfit / totalBuyValue * 100).rounded(scale: 2, mode: .plain) : 0

        return AssetSnapshotEntity(
            totalAsset: NSDecimalNumber(decimal: totalAssetDecimal).int64Value,
            totalCurrency: currentAsset.totalCurrency,
            totalCoinValue: NSDecimalNumber(decimal: totalMarketValue).int64Value,
            holdingProfit: totalProfit,
            holdingYieldRate: yieldRate,
            evaluatedCoins: evaluatedCoins
        )
    }
}
