//
//  CurrentKRWUseCase.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

final class TradeUseCase: TradeUseCaseProtocol {
    private let chargeRepository: ChargeRepositoryProtocol
    private let tradeRepository: TradeRepositoryProtocol
    private let holdingRepository: HoldingRepositoryProtocol

    init(
        chargeRepository: ChargeRepositoryProtocol,
        tradeRepository: TradeRepositoryProtocol,
        holdingRepository: HoldingRepositoryProtocol
    ) {
        self.chargeRepository = chargeRepository
        self.tradeRepository = tradeRepository
        self.holdingRepository = holdingRepository
    }

    func getCurrentCurrency() -> Decimal {
        let charges = chargeRepository.fetchAllCharges()
        let trades = tradeRepository.getAllTrade()

        return CurrentAssetCalculator.calculateAvailableKRW(
            charges: charges,
            trades: trades
        )
    }

    func getHoldingAmount(of name: String) -> Decimal {
        guard let holding = holdingRepository.getHoldingMarket(name: name) else { return 0 }
        return holding.totalBuyPrice
    }
}
