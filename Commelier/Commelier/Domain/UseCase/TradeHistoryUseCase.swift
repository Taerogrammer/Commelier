//
//  TradeHistoryUseCase.swift
//  CrypMulator
//
//  Created by 김태형 on 4/3/25.
//

import Foundation

final class TradeHistoryUseCase: TradeHistoryUseCaseProtocol {
    private let tradeRepository: TradeRepositoryProtocol

    init(tradeRepository: TradeRepositoryProtocol) {
        self.tradeRepository = tradeRepository
    }

    func getTradeHistory() -> [TradeHistoryEntity] {
        return tradeRepository.getAllTrade().reversed().map { $0.toHistoryEntity() }
    }

}
