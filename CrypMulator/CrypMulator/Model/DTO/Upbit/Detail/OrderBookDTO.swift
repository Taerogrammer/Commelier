//
//  OrderBookDTO.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Foundation

struct OrderBookDTO: Decodable {
    let type: String
    let code: String
    let timestamp: Int
    let totalAskSize: Double
    let totalBidSize: Double
    let orderbookUnits: [OrderbookUnitDTO]

    enum CodingKeys: String, CodingKey {
        case type, code, timestamp
        case totalAskSize = "total_ask_size"
        case totalBidSize = "total_bid_size"
        case orderbookUnits = "orderbook_units"
    }
}

struct OrderbookUnitDTO: Decodable {
    let askPrice: Double
    let bidPrice: Double
    let askSize: Double
    let bidSize: Double

    enum CodingKeys: String, CodingKey {
        case askPrice = "ask_price"
        case bidPrice = "bid_price"
        case askSize = "ask_size"
        case bidSize = "bid_size"
    }
}

extension OrderBookDTO {
    func toEntity() -> OrderBookEntity {
        return OrderBookEntity(
            code: code,
            time: Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000),
            asks: orderbookUnits.map { OrderUnit(price: $0.askPrice, size: $0.askSize) },
            bids: orderbookUnits.map { OrderUnit(price: $0.bidPrice, size: $0.bidSize) }
        )
    }
}
