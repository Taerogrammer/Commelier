//
//  TickerDTO.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Foundation

struct DelistingDate: Decodable {
    let year: Int
    let month: Int
    let day: Int

    var formatted: String {
        String(format: "%04d-%02d-%02d", year, month, day)
    }
}

struct TickerDTO: Decodable {
    let type: String
    let code: String
    let openingPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let tradePrice: Double
    let prevClosingPrice: Double
    let accTradePrice: Double
    let change: String
    let changePrice: Double
    let signedChangePrice: Double
    let changeRate: Double
    let signedChangeRate: Double
    let askBid: String
    let tradeVolume: Double
    let accTradeVolume: Double
    let tradeDate: String
    let tradeTime: String
    let tradeTimestamp: Int64
    let accAskVolume: Double
    let accBidVolume: Double
    let highest52WeekPrice: Double
    let highest52WeekDate: String
    let lowest52WeekPrice: Double
    let lowest52WeekDate: String
    let marketState: String
    let isTradingSuspended: Bool
    let delistingDate: DelistingDate?
    let marketWarning: String
    let timestamp: Int64
    let accTradePrice24h: Double
    let accTradeVolume24h: Double
    let streamType: String

    enum CodingKeys: String, CodingKey {
        case type, code
        case openingPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case tradePrice = "trade_price"
        case prevClosingPrice = "prev_closing_price"
        case accTradePrice = "acc_trade_price"
        case change
        case changePrice = "change_price"
        case signedChangePrice = "signed_change_price"
        case changeRate = "change_rate"
        case signedChangeRate = "signed_change_rate"
        case askBid = "ask_bid"
        case tradeVolume = "trade_volume"
        case accTradeVolume = "acc_trade_volume"
        case tradeDate = "trade_date"
        case tradeTime = "trade_time"
        case tradeTimestamp = "trade_timestamp"
        case accAskVolume = "acc_ask_volume"
        case accBidVolume = "acc_bid_volume"
        case highest52WeekPrice = "highest_52_week_price"
        case highest52WeekDate = "highest_52_week_date"
        case lowest52WeekPrice = "lowest_52_week_price"
        case lowest52WeekDate = "lowest_52_week_date"
        case marketState = "market_state"
        case isTradingSuspended = "is_trading_suspended"
        case delistingDate = "delisting_date"
        case marketWarning = "market_warning"
        case timestamp
        case accTradePrice24h = "acc_trade_price_24h"
        case accTradeVolume24h = "acc_trade_volume_24h"
        case streamType = "stream_type"
    }
}

extension TickerDTO {
    func toLivePrice() -> LivePriceEntity {
        return LivePriceEntity(
            market: code,
            price: tradePrice,
            change: change,
            signedChangeRate: signedChangeRate,
            signedChangePrice: signedChangePrice,
            priceChangeState: PriceChangeState(rawValue: change) ?? .even
        )
    }
    
    func toSymbolInfo() -> SymbolInfoEntity {
        return SymbolInfoEntity(
            highPrice: highPrice,
            lowPrice: lowPrice,
            accTradePrice: accTradePrice,
            accTradeVolume: accTradeVolume,
            prevClosingPrice: prevClosingPrice,
            signedChangeRate: signedChangeRate,
            highest52WeekPrice: highest52WeekPrice,
            highest52WeekDate: highest52WeekDate,
            lowest52WeekPrice: lowest52WeekPrice,
            lowest52WeekDate: lowest52WeekDate
        )
    }
}
