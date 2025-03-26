//
//  StringLiteral.swift
//  CrypMulator
//
//  Created by 김태형 on 3/25/25.
//

import Foundation

enum StringLiteral {

    enum Currency {
        static let krw = "KRW"
    }

    enum NavigationTitle {
        static let ticker = "거래소"
        static let information = "코인 정보"
        static let portfolio = "포트폴리오"
    }

    enum TabBar {
        static let ticker = "거래소"
        static let information = "코인 정보"
        static let portfolio = "포트폴리오"
    }

    enum Portfolio {
        static let totalBuyPrice = "총 매수"
        static let totalEvaluation = "총 평가"
        static let profitLoss = "평가손익"
        static let yieldRate = "수익률"
    }

    enum Ticker {
        static let coin = "코인"
        static let currentPrice = "현재가"
        static let priceChanged = "전일대비"
        static let tradeVolume = "거래대금"
    }
}
