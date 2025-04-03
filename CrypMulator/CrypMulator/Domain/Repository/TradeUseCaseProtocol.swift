//
//  CurrentAssetUseCaseProtocol.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

protocol TradeUseCaseProtocol: AnyObject {
    func getCurrentCurrency() -> Int64
    func getHoldingAmount(of market: String) -> Int64
    func getHoldingQuantity(of name: String) -> Decimal
    func trade(with entity: TradeEntity)
}
