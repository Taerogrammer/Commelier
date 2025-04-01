//
//  PortfolioSummaryEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import Foundation

struct PortfolioSummaryEntity {
    let totalBuy: Decimal                   // 총 매수
    let totalEvaluation: Decimal            // 총 평가
    let profitLoss: Decimal                 // 평가 손익
    let yieldRate: Decimal                  // 수익률
    let yieldRateState: PriceChangeState    // 수익률 상태
}
