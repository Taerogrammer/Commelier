//
//  TradeFactory.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Foundation

struct TradeFactory {
    static func make(with market: String, type: OrderType) -> TradeViewController {
        let webSocket = WebSocketManager.shared

        let chargeRepo = ChargeRepository()
        let tradeRepo = TradeRepository()
        let holdingRepo = HoldingRepository()
        let tradeUseCase = TradeUseCase(
            chargeRepository: chargeRepo,
            tradeRepository: tradeRepo,
            holdingRepository: holdingRepo
        )

        let tradeVM = TradeViewModel(type: type,
                                     name: market,
                                     webSocket: webSocket,
                                     tradeUseCase: tradeUseCase)

        // TODO: - File 생성 후 엔티티 바로 주입하기
        return TradeViewController(
            viewModel: tradeVM,
            titleEntity: NavigationTitleEntity(imageURLString: nil, title: market),
            type: type)
    }
}
