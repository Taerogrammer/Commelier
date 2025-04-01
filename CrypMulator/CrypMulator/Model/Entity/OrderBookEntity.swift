//
//  OrderEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Foundation

struct OrderBookEntity {
    let code: String
    let time: Date
    let asks: [OrderUnit]
    let bids: [OrderUnit]
}

struct OrderUnit {
    let price: Double
    let size: Double
}
