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
        let totalAssetVM = TotalAssetViewModel()
        let chargeRepository = ChargeRepository()
        let totalAssetVC = TotalAssetViewController(
            viewModel: totalAssetVM,
            chargeRepository: chargeRepository
        )

        let tradeRepository = TradeRepository()
        let tradeUseCase = TradeHistoryUseCase(tradeRepository: tradeRepository)
        let transactionVC = TradeHistoryViewController(useCase: tradeUseCase)
        return PortfolioViewController(
            totalAssetViewController: totalAssetVC,
            transactionViewController: transactionVC
        )
    }
}
