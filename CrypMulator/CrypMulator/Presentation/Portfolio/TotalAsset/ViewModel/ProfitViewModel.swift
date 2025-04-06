//
//  ProfitViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 4/5/25.
//

import Foundation

final class ProfitViewModel: ViewModel {
    private let portfolioUseCase: PortfolioUseCaseProtocol

    init(portfolioUseCase: PortfolioUseCaseProtocol) {
        self.portfolioUseCase = portfolioUseCase
    }

    struct Input {}

    struct Output {
        let totalProfitAmount: String
        let totalProfitRate: String
    }

    func transform(input: Input) -> Output {
        let profits = portfolioUseCase.getRealizedProfit()

        let totalBuyCost = profits.map { $0.totalBuyCost }.reduce(0, +)
        let totalSellRevenue = profits.map { $0.totalSellRevenue }.reduce(0, +)

        let totalProfit = totalSellRevenue - totalBuyCost

        let profitRate: Decimal
        if totalBuyCost > 0 {
            profitRate = (totalProfit / totalBuyCost * 100).rounded(scale: 2)
        } else {
            profitRate = 0
        }

        return Output(
            totalProfitAmount: formatProfit(totalProfit),
            totalProfitRate: "\(profitRate) " + StringLiteral.Operator.percentage
        )
    }

    private func formatProfit(_ amount: Decimal) -> String {
        let number = NSDecimalNumber(decimal: amount)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0

        let formatted = formatter.string(from: number) ?? "0"
        let prefix = amount >= 0 ? StringLiteral.Operator.plus : ""
        return "\(prefix)\(formatted) " + StringLiteral.Currency.krw
    }
}

extension Decimal {
    func rounded(scale: Int) -> Decimal {
        var result = Decimal()
        var selfCopy = self
        NSDecimalRound(&result, &selfCopy, scale, .plain)
        return result
    }
}
