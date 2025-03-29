//
//  CoingeckoSearchResponse.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation

// TODO: - 제거 예정
struct CoingeckoSearchResponse: Decodable {
    let coins: [CoinData]
}

struct CoinData: Decodable {
    let id: String
    let name: String
    let symbol: String
    let market_cap_rank: Int?
    let thumb: String
}
