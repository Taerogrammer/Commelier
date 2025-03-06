//
//  UpbitMarketResponse.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation

struct UpbitMarketResponse: Decodable {
    let market: String
    let trade_price: Double
    let change: String
    let signed_change_price: Double
    let signed_change_rate: Double
    let acc_trade_price_24h: Double
}
