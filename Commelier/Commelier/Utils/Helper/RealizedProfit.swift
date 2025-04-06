//
//  RealizedProfit.swift
//  CrypMulator
//
//  Created by 김태형 on 4/5/25.
//

import Foundation

struct RealizedProfit {
    let market: String
    let totalBuyCost: Decimal
    let totalSellRevenue: Decimal

    var yieldRate: Decimal {
        guard totalBuyCost > 0 else { return 0 }
        return (totalSellRevenue - totalBuyCost) / totalBuyCost * 100
    }
}

// TODO: - 식 완벽히 이해하기
// TODO: - 덱으로 구현하기
final class RealizedProfitCalculator {

    /// 마켓별 누적 실현 손익 및 수익률 계산기 (FIFO 기반)
    /// - Parameter trades: 거래 내역 (매수/매도)
    /// - Returns: 마켓별 RealizedProfit 리스트
    static func calculate(for trades: [TradeEntity]) -> [RealizedProfit] {
        // 1. 마켓별 그룹화
        let grouped = Dictionary(grouping: trades) { $0.name }

        // 2. 각 마켓마다 손익 계산
        return grouped.map { (market, trades) in

            // 3. 거래는 시간순 정렬 (FIFO 위해)
            let sorted = trades.sorted { $0.timestamp < $1.timestamp }

            // 4. 매수 내역 FIFO 큐: (수량, 단가)
            var buyQueue: [(quantity: Decimal, unitPrice: Decimal)] = []

            // 5. 누적 합산용 변수
            var totalBuyCost: Decimal = 0
            var totalSellRevenue: Decimal = 0

            // 6. 거래 순회
            for trade in sorted {
                let quantity = trade.transactionQuantity
                let unitPrice = trade.unitPrice // 단가: Decimal

                if trade.buySell.lowercased() == "buy" {
                    // 7. 매수는 큐에 넣기만
                    buyQueue.append((quantity, unitPrice))
                } else if trade.buySell.lowercased() == "sell" {
                    // 8. 매도 시: 대응되는 매수 내역에서 원가 추출
                    var remainingToSell = quantity
                    var buyCostForThisSell: Decimal = 0

                    // 9. FIFO 방식으로 매수 내역 소모
                    while remainingToSell > 0 && !buyQueue.isEmpty {
                        var front = buyQueue.removeFirst()

                        // 매도수량
                        let sellQty = min(remainingToSell, front.quantity)
                        buyCostForThisSell += sellQty * front.unitPrice
                        remainingToSell -= sellQty

                        // 매수 일부만 소모되었다면 남은 것 다시 첫 번째 자리에 추가
                        if front.quantity > sellQty {
                            let leftover = front.quantity - sellQty
                            buyQueue.insert((leftover, front.unitPrice), at: 0)
                        }
                    }

                    // 10. 매도 수익 = 전체 수량 × 매도 단가
                    let sellRevenue = quantity * unitPrice

                    // 11. 누적값 업데이트
                    totalBuyCost += buyCostForThisSell
                    totalSellRevenue += sellRevenue
                }
            }

            // 12. 결과 구성
            return RealizedProfit(
                market: market,
                totalBuyCost: totalBuyCost,
                totalSellRevenue: totalSellRevenue
            )
        }
    }
}
