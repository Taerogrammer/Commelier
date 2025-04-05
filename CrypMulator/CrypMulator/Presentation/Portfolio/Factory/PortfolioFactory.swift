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
        let holdingRepository = HoldingRepository()
        let webSocket: WebSocketProvider = WebSocketManager.shared

        let tradeUseCase = TradeHistoryUseCase(tradeRepository: tradeRepository)
        let transactionVC = TradeHistoryViewController(useCase: tradeUseCase)
        let portfolioUseCase = PortfolioUseCase(
            chargeRepository: chargeRepository,
            tradeRepository: tradeRepository,
            holdingRepository: holdingRepository)

        let totalAssetVM = TotalAssetViewModel(
            portfolioUseCase: portfolioUseCase,
            webSocket: webSocket)
        let profitVM = ProfitViewModel(portfolioUseCase: portfolioUseCase)
        let totalAssetVC = TotalAssetViewController(
            viewModel: totalAssetVM,
            chargeRepository: chargeRepository,
            profitViewModel: profitVM
        )
        return PortfolioViewController(
            totalAssetViewController: totalAssetVC,
            transactionViewController: transactionVC
        )
    }
}
