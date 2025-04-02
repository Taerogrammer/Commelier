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
        static let won = "원"
        static let wonMark = "₩"
        static let percentage = "%"
        static let tmpCoin = "BTC(변경)"
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
        static let assetOverview = "보유내역"
        static let portfolioRatio = "보유자산 포트폴리오"
        static let totalProfit = "투자손익"
        static let transaction = "거래내역"
        static let totalBuyPrice = "총 매수"
        static let totalEvaluation = "총 평가"
        static let profitLoss = "평가손익"
        static let yieldRate = "수익률"
        static let totalAsset = "총 보유자산"
        static let coinAsset = "가상 자산"
        static let chartText = "보유비중\n(%)"
        static let cumulativeProfit = "누적 손익"
        static let cumulativeRate = "누적 손익률"
        static let chargeQuestion = "얼마를 충전하시겠어요?"
    }

    enum Ticker {
        static let coin = "코인"
        static let currentPrice = "현재가"
        static let priceChanged = "전일대비"
        static let tradeVolume = "거래대금"
    }

    enum FavoriteMessage {
        static let add = "관심 목록에 추가되었습니다"
        static let remove = "관심 목록에서 제거되었습니다"
    }

    enum Information {
        static let popular = "인기 검색어"
        static let favorite = "관심 목록"
        static let graph = "그래프"
        static let orderBook = "호가"
        static let summary = "종목정보"
    }

    enum Button {
        static let charge = "충전하기"
        static let sell = "가상 매도하기"
        static let buy = "가상 매수하기"
        static let confirm = "확인"
    }

    enum Trade {
        static let currentPrice = "현재가"
        static let sellPrice = "매도 금액"
        static let buyPrice = "매수 금액"
        static let holdingAsset = "보유자산"
        static let holdingQuantity = "보유량"
        static let sellPlaceholder = "매도할 금액을 입력해주세요"
        static let buyPlaceholder = "매수할 금액을 입력해주세요"
        static let sellBalance = "평가 금액"
        static let buyBalance = "보유 가상현금"
        static let total = "총"
        static let loadingDots = "..."
        static let defaultString = "0"
        static let success = "거래 성공"
        static let failure = "거래 실패"
        static let successMessage = "정상적으로 거래가 완료되었습니다."
        static let failureMessage = "문제가 발생했습니다. 다시 시도해주세요."
    }
}
