//
//  String+Extension.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import Foundation

extension String {
    static func convertDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 M월 d일"
        let convertedToDate: Date = dateFormatter.date(from: date) ?? Date()
        return dateFormatter.string(from: convertedToDate)
    }
}
