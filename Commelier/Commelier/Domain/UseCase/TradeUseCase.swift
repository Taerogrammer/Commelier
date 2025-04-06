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

    func getCurrentCurrency() -> Int64 {
        let charges = chargeRepository.fetchAllCharges()
        let trades = tradeRepository.getAllTrade()

        return Calculator.calculateAvailableKRW(
            charges: charges,
            trades: trades
        )
    }

    func getHoldingMarket(name: String) -> HoldingDTO? {
        return holdingRepository.getHoldingMarket(name: name)
    }

    func getHoldingAmount(of name: String) -> Int64 {
        guard let holding = holdingRepository.getHoldingMarket(name: name) else { return 0 }
        return holding.totalBuyPrice
    }

    func getHoldingQuantity(of name: String) -> Decimal {
        guard let holding = holdingRepository.getHoldingMarket(name: name) else { return 0 }
        return holding.transactionQuantity
    }

    func trade(with entity: TradeEntity) {
        tradeRepository.trade(entity)
        holdingRepository.saveTradeResult(entity)
    }

}
