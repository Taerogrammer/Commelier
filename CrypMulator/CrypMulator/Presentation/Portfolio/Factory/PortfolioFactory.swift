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
        let transactionVC = TradeHistoryViewController()
        return PortfolioViewController(
            totalAssetViewController: totalAssetVC,
            transactionViewController: transactionVC
        )
    }
}
