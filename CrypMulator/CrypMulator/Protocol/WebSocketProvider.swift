//
//  WebSocketProvider.swift
//  CrypMulator
//
//  Created by 김태형 on 3/31/25.
//

import Combine
import Foundation

protocol WebSocketProvider {
    var tickerPublisher: AnyPublisher<TickerEntity, Never> { get }
    func connect()
    func disconnect()
    func send(market: String)
}
