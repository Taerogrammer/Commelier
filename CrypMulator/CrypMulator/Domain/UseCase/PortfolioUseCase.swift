//
//  PortfolioUseCase.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
//

import Foundation

final class PortfolioUseCase: PortfolioUseCaseProtocol {
    private let chargeRepository: ChargeRepositoryProtocol
    private let tradeRepository: TradeRepositoryProtocol

    init(chargeRepository: ChargeRepositoryProtocol, tradeRepository: TradeRepositoryProtocol) {
        self.chargeRepository = chargeRepository
        self.tradeRepository = tradeRepository
    }

    func getTotalCurrency() -> Int64 {
        let charges = chargeRepository.fetchAllCharges()
        let trades = tradeRepository.getAllTrade()

        // 충전액 전체 합산
        let totalChargeAmount = charges.reduce(0) { $0 + $1.amount }

        // 매수 / 매도 분리
        let buyTrades = trades.filter { $0.buySell.lowercased() == "buy" }
        let sellTrades = trades.filter { $0.buySell.lowercased() == "sell" }

        // 매수 / 매도 금액 계산
        let totalBuyAmount = buyTrades.reduce(Decimal(0)) { $0 + (Decimal($1.price)) }
        let totalSellAmount = sellTrades.reduce(Decimal(0)) { $0 + (Decimal($1.price)) }

        // 현재 보유 자산 계산
        let totalAssetDecimal = Decimal(totalChargeAmount) + totalSellAmount - totalBuyAmount
        let totalCurrency = NSDecimalNumber(decimal: totalAssetDecimal).int64Value

        return totalCurrency
    }


}
