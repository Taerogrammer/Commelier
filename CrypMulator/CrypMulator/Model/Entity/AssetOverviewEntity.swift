//
//  AssetSummaryEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

struct AssetOverviewEntity {
    let totalAsset: Decimal       // 총 보유 자산
    let krwBalance: Decimal       // 원화
    let virtualAsset: Decimal     // 가상 자산 총 평가
    let profitLoss: Decimal       // 평가 손익
    let yieldRate: Decimal        // 수익률 (%)
    let yieldRateState: PriceChangeState
}
