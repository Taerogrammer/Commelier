//
//  CoingeckoCoinResponse.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation

struct CoingeckoCoinResponse: Decodable {
    let id: String
    let symbol: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Double
    let sparkline_in_7d: Price
    let last_updated: String
    let high_24h: Double
    let low_24h: Double
    let ath: Double
    let ath_date: String
    let atl: Double
    let atl_date: String
    let market_cap: Double
    let fully_diluted_valuation: Double
    let total_volume: Double
}

struct Price: Decodable {
    let price: [Double]
}
