//
//  PortfolioUseCaseProtocol.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
//

import Foundation

protocol PortfolioUseCaseProtocol: AnyObject {

    /// 총 현금 자산 (총 보유 자산이 아님)
    func getTotalCurrency() -> Int64

    /// 보유 코인 목록
    func getHoldings() -> [HoldingDTO]

    /// 엔티티 반환
    func getCurrentAssetEntity() -> CurrentAssetEntity

    // 누적 투자 손익
    func getRealizedProfit() -> [RealizedProfit]
}
