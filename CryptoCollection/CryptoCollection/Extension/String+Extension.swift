//
//  String+Extension.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import Foundation

extension String {
    static func convertPriceDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 M월 d일"
        let convertedToDate: Date = dateFormatter.date(from: date) ?? Date()
        return dateFormatter.string(from: convertedToDate)
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
}
