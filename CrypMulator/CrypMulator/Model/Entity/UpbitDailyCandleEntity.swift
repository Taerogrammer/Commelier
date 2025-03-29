//
//  UpbitDailyCandleEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import Foundation

struct UpbitDailyCandleEntity {
    let market: String
    let candle_date_time_kst: String
    let opening_price: Double
    let high_price: Double
    let low_price: Double
    let trade_price: Double
    let timestamp: Int64
}
