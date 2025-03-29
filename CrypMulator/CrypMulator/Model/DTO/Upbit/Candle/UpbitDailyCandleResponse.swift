//
//  UpbitCandleMinuteResponse.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import Foundation

struct UpbitDailyCandleResponse: Decodable {
    let market: String
    let candleDateTimeUTC: String
    let candleDateTimeKST: String
    let openingPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let tradePrice: Double
    let timestamp: Int64
    let candleAccTradePrice: Double
    let candleAccTradeVolume: Double
    let prevClosingPrice: Double
    let changePrice: Double
    let changeRate: Double

    enum CodingKeys: String, CodingKey {
        case market
        case candleDateTimeUTC = "candle_date_time_utc"
        case candleDateTimeKST = "candle_date_time_kst"
        case openingPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case tradePrice = "trade_price"
        case timestamp
        case candleAccTradePrice = "candle_acc_trade_price"
        case candleAccTradeVolume = "candle_acc_trade_volume"
        case prevClosingPrice = "prev_closing_price"
        case changePrice = "change_price"
        case changeRate = "change_rate"
    }
}

extension UpbitDailyCandleResponse {
    func toEntity() -> ChartEntity {
        return ChartEntity(
            date: String.convertPriceDate(date: candleDateTimeKST),
            price: tradePrice)
    }
}
