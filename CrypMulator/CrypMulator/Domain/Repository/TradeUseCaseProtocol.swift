//
//  CurrentAssetUseCaseProtocol.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

protocol TradeUseCaseProtocol: AnyObject {
    func getCurrentCurrency() -> Decimal
    func getHoldingAmount(of market: String) -> Decimal
    func trade(with entity: TradeEntity)
}
