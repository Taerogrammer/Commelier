//
//  PortfolioSummaryRepository.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation
import RealmSwift

final class PortfolioSummaryRepository: PortfolioSummaryRepositoryProtocol {
    private let realm = try! Realm()

    func getFileURL() { print(realm.configuration.fileURL as Any) }

    func getSummary(currentPrices: [String : Decimal]) -> PortfolioSummaryEntity {
        let holdings = realm.objects(HoldingObject.self)

        var totalBuy: Decimal = 0
        var totalEvaluation: Decimal = 0

        for holding in holdings {
            let buy = holding.totalBuyPrice.decimalValue
            totalBuy += buy

            if let currentPrice = currentPrices[holding.symbol] {
                let evaluation = holding.transactionQuantity.decimalValue * currentPrice
                totalEvaluation += evaluation
            }
        }

        let profitLoss = totalEvaluation - totalBuy
        let yieldRate: Decimal = totalBuy > 0 ? (profitLoss / totalBuy * 100) : 0
        let yieldRateState: PriceChangeState
        switch yieldRate {
        case ..<0:
            yieldRateState = .fall
        case 0:
            yieldRateState = .even
        default:
            yieldRateState = .rise
        }

        return PortfolioSummaryEntity(
            totalBuy: totalBuy,
            totalEvaluation: totalEvaluation,
            profitLoss: profitLoss,
            yieldRate: yieldRate,
            yieldRateState: yieldRateState)
    }
}
