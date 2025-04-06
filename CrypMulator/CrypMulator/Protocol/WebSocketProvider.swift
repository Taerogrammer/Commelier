//
//  WebSocketProvider.swift
//  CrypMulator
//
//  Created by 김태형 on 3/31/25.
//

import Combine
import Foundation

protocol WebSocketProvider {
    var orderbookPublisher: AnyPublisher<OrderBookEntity, Never> { get }
    var livePricePublisher: AnyPublisher<LivePriceEntity, Never> { get }
    var symbolInfoPublisher: AnyPublisher<SymbolInfoEntity, Never> { get }
    func connect()
    func disconnect()
    func send(market: String)
    func send(markets: [String])
}
