//
//  HoldingRepositoryProtocol.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

protocol HoldingRepositoryProtocol {
    func getHoldingMarket(name: String) -> HoldingDTO?
    func saveTradeResult(_ entity: TradeEntity)
    func getHolding() -> [HoldingDTO]
}
