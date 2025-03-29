//
//  MarketInfoEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import Foundation

struct CoinInfoEntity {
    let highPrice: Double                     // 고가
    let lowPrice: Double                      // 저가
    let accTradePrice: Double                 // 당일 누적 거래금액
    let accTradeVolume: Double                // 당일 누적 거래량
    let prevClosingPrice: Double              // 전일 종가
    let signedChangeRate: Double              // 전일 대비 변동률
    let highest52WeekPrice: Double            // 52주 최고가
    let highest52WeekDate: String             // 52주 최고가 날짜
    let lowest52WeekPrice: Double             // 52주 최저가
    let lowest52WeekDate: String              // 52주 최저가 날짜
}
