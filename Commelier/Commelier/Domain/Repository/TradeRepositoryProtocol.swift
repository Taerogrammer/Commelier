//
//  TradeRepositoryProtocol.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

protocol TradeRepositoryProtocol: AnyObject {
    func getAllTrade() -> [TradeEntity]
    func trade(_ entity: TradeEntity)
}
