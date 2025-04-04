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

    /// 총 가상 자산: 현재가를 기반으로 계산
//    func getTotalCoin() -> Int64

    // 포트폴리오
    // 누적 투자 손익
}
