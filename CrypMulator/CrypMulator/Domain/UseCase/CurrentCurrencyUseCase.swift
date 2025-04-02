//
//  CurrentKRWUseCase.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

final class CurrentCurrencyUseCase: CurrentCurrencyUseCaseProtocol {
    private let chargeRepository: ChargeRepositoryProtocol
    private let tradeRepository: TradeRepositoryProtocol

    init(
        chargeRepository: ChargeRepositoryProtocol,
        tradeRepository: TradeRepositoryProtocol
    ) {
        self.chargeRepository = chargeRepository
        self.tradeRepository = tradeRepository
    }

    func getCurrentCurrency() -> Decimal {
        let charges = chargeRepository.fetchAllCharges()
        let trades = tradeRepository.getAllTrade()

        return CurrentAssetCalculator.calculateAvailableKRW(
            charges: charges,
            trades: trades
        )
    }
}
