//
//  TickerFactory.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import UIKit

struct TickerFactory {
    private init() {}
    static func make() -> TickerViewController {
        let chargeRepository = ChargeRepository()
        let tradeRepository = TradeRepository()
        let holdingRepository = HoldingRepository()
        let webSocket: WebSocketProvider = WebSocketManager.shared

        let listVM = TickerListViewModel()
        let portfolioUseCase = PortfolioUseCase(
            chargeRepository: chargeRepository,
            tradeRepository: tradeRepository,
            holdingRepository: holdingRepository)

        let vm = TickerViewModel(
            tickerListViewModel: listVM,
            portfolioUseCase: portfolioUseCase,
            webSocket: webSocket
        )

        return TickerViewController(tickerViewModel: vm)
    }
}
