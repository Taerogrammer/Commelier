//
//  String+Extension.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import Foundation

extension String {
    static func convertPriceDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        guard let date = formatter.date(from: date) else {
            print("❌ 날짜 파싱 실패: \(date)")
            return "날짜 에러"
        }

        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale(identifier: "ko_KR")
        displayFormatter.dateFormat = "yy-MM-dd"

        return displayFormatter.string(from: date)
    }

    static func convertCandleDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        guard let date = formatter.date(from: date) else {
            print("❌ 날짜 파싱 실패: \(date)")
            return "날짜 에러"
        }

        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale(identifier: "ko_KR")
        displayFormatter.dateFormat = "yyyy.MM.dd"

        return displayFormatter.string(from: date)
    }

    static func convertChartDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d HH:mm:ss 업데이트"
        let convertedToDate: Date = dateFormatter.date(from: date) ?? Date()
        return dateFormatter.string(from: convertedToDate)
    }

    static func convertUpdateDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm 기준"
        return dateFormatter.string(from: date)
    }

    static func convertTradeHistoryDate(timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: date)
    }
}
