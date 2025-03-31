//
//  MarketInfoEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import Foundation

struct SymbolInfoEntity {
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

extension SymbolInfoEntity {
    func toDetailSection() -> DetailSection {
        return DetailSection(title: "종목정보", items: [
            DetailInformation(
                title: "고가",
                money: FormatUtility.formattedPrice(highPrice) + StringLiteral.Currency.wonMark,
                date: ""
            ),
            DetailInformation(
                title: "저가",
                money: FormatUtility.formattedPrice(lowPrice) + StringLiteral.Currency.wonMark,
                date: ""
            ),
            DetailInformation(
                title: "당일 누적 거래금액",
                money: FormatUtility.formattedPrice(accTradePrice) + StringLiteral.Currency.wonMark,
                date: ""
            ),
            DetailInformation(
                title: "당일 누적 거래량",
                money: FormatUtility.formattedVolume(accTradeVolume) + StringLiteral.Currency.wonMark,
                date: ""
            ),
            DetailInformation(
                title: "전일 종가",
                money: FormatUtility.formattedPrice(prevClosingPrice) + StringLiteral.Currency.wonMark,
                date: ""
            ),
            DetailInformation(
                title: "전일 대비 변동률",
                money: FormatUtility.formattedPercent(signedChangeRate) + StringLiteral.Currency.percentage,
                date: ""
            ),
            DetailInformation(
                title: "52주 최고가",
                money: FormatUtility.formattedPrice(highest52WeekPrice) + StringLiteral.Currency.wonMark,
                date: highest52WeekDate
            ),
            DetailInformation(
                title: "52주 최저가",
                money: FormatUtility.formattedPrice(lowest52WeekPrice) + StringLiteral.Currency.wonMark,
                date: lowest52WeekDate
            )
        ])
    }
}
