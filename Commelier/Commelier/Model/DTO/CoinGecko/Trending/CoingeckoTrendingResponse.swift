//
//  CoingeckoTrending.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation

struct CoingeckoTrendingResponse: Decodable {
    let coins: [CoinItem]
}

struct CoinItem: Decodable {
    let item: Coin
}

struct Coin: Decodable {
    let id: String
    let symbol: String
    let name: String
    let thumb: String
    let score: Int
    let market_cap_rank: Int
    let data: PriceChangeData
}

struct PriceChangeData: Decodable {
    let price_change_percentage_24h: KrwChangePercentage
    let market_cap: String
    let total_volume: String
}

struct KrwChangePercentage: Decodable {
    let krw: Double
}
