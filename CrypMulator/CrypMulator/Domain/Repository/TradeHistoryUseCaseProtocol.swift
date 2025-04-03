//
//  TradeHistoryUseCaseProtocol.swift
//  CrypMulator
//
//  Created by 김태형 on 4/3/25.
//

import Foundation

protocol TradeHistoryUseCaseProtocol: AnyObject {
    func getTradeHistory() -> [TradeHistoryEntity]
}
