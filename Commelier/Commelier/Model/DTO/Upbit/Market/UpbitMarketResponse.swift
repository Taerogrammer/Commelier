//
//  UpbitMarketResponse.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation

let million: Double = 1_000_000
enum change {
    case EVEN

}

struct UpbitMarketResponse: Decodable {
    let market: String
    let trade_date: String?
    let trade_time: String?
    let trade_date_kst: String?
    let trade_time_kst: String?
    let trade_timestamp: Int64?
    let opening_price: Double?
    let high_price: Double?
    let low_price: Double?
    let trade_price: Double?
    let prev_closing_price: Double?
    let change: String
    let change_price: Double?
    let change_rate: Double?
    let signed_change_price: Double?
    let signed_change_rate: Double?
    let trade_volume: Double?
    let acc_trade_price: Double?
    let acc_trade_price_24h: Double?
    let acc_trade_volume: Double?
    let acc_trade_volume_24h: Double?
    let highest_52_week_price: Double?
    let highest_52_week_date: String?
    let lowest_52_week_price: Double?
    let lowest_52_week_date: String?
    let timestamp: Int64?
}

extension UpbitMarketResponse {
    func toEntity() -> UpbitMarketEntity? {
        guard let trade_price,
              let signed_change_price,
              let signed_change_rate,
              let acc_trade_price_24h else {
            return nil
        }

        return UpbitMarketEntity(
            market: market,
            trade_price: trade_price,
            change: change,
            signed_change_price: signed_change_price,
            signed_change_rate: signed_change_rate,
            acc_trade_price_24h: acc_trade_price_24h
        )
    }
}
