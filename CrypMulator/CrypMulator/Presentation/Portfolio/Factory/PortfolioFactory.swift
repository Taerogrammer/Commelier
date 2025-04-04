//
//  PortfolioFactory.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

struct PortfolioFactory {
    private init() {}

    static func make() -> PortfolioViewController {
        let chargeRepository = ChargeRepository()
        let tradeRepository = TradeRepository()
        let tradeUseCase = TradeHistoryUseCase(tradeRepository: tradeRepository)
        let transactionVC = TradeHistoryViewController(useCase: tradeUseCase)
        let portfolioUseCase = PortfolioUseCase(chargeRepository: chargeRepository, tradeRepository: tradeRepository)

        let totalAssetVM = TotalAssetViewModel(portfolioUseCase: portfolioUseCase)
        let totalAssetVC = TotalAssetViewController(
            viewModel: totalAssetVM,
            chargeRepository: chargeRepository
        )
        return PortfolioViewController(
            totalAssetViewController: totalAssetVC,
            transactionViewController: transactionVC
        )
    }
}
