//
//  CoingeckoTrending.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation

struct CoingeckoTrendingResponse: Decodable {
    let coins: [CoinItem]
    let nfts: [Nft]
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
    let data: PriceChangeData
}

struct PriceChangeData: Decodable {
    let price_change_percentage_24h: KrwChangePercentage
    let sparkline: String
}

struct KrwChangePercentage: Decodable {
    let krw: Double
}

struct Nft: Decodable {
    let id: String
    let name: String
    let thumb: String
    let data: NftData
}

struct NftData: Decodable {
    let floor_price: String
    let floor_price_in_usd_24h_percentage_change: String

    var floor_price_in_usd_24h_percentage_change_description: String {
        let doubleValue = Double(floor_price_in_usd_24h_percentage_change)
        return FormatUtility.numberConverter(number: doubleValue ?? 0.0)
    }
}
