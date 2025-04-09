//
//  AssetSnapshotEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
//

import Foundation
import NumberterKit

struct AssetSnapshotEntity {
    let totalAsset: Decimal               // 총 자산 = 현금 + 코인 평가 금액 합계
    let totalCurrency: Decimal            // 보유 현금
    let totalCoinValue: Decimal           // 코인 평가금액 총합
    let totalBuyValue: Decimal              // 총 매수
    let holdingProfit: Decimal          // 평가 손익 총합
    let holdingYieldRate: Decimal       // 평가 수익률 평균

}

struct AssetEvaluator {
    static func evaluate(
        from currentAsset: CurrentAssetEntity,
        currentPrices: [String: Decimal]
    ) -> AssetSnapshotEntity {
        var totalMarketValue: Decimal = 0
        var totalBuyValue: Decimal = 0
        var totalProfit: Decimal = 0

        for holding in currentAsset.totalCoin {
            guard let currentPrice = currentPrices[holding.name] else {
                print("⚠️ 현재가 없음 → \(holding.name)")
                continue
            }

            let quantity = holding.transactionQuantity
            let buyPrice = holding.totalBuyPrice

            let marketValue = currentPrice * quantity
            let profit = Calculator.profitAmount(transactionQuantity: quantity, totalBuyPrice: buyPrice, currentPrice: currentPrice)

            totalMarketValue += marketValue
            totalBuyValue += buyPrice.decimalValue
            totalProfit += profit
        }

        let totalAssetDecimal = Decimal(currentAsset.totalCurrency) + totalMarketValue
        let yieldRate: Decimal = totalBuyValue > 0 ? (totalProfit / totalBuyValue * 100).rounded(scale: 2, mode: .plain) : 0

        return AssetSnapshotEntity(
            totalAsset: totalAssetDecimal,
            totalCurrency: currentAsset.totalCurrency.decimalValue,
            totalCoinValue: totalMarketValue,
            totalBuyValue: totalBuyValue,
            holdingProfit: totalProfit,
            holdingYieldRate: yieldRate
        )
    }
}
