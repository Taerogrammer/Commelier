//
//  FormatUtility.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import Foundation

enum FormatUtility {

    // TODO: - 다시 수정 (minimum 추가)
    static func numberConverter(number: Double, style: NumberFormatter.Style = .decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale(identifier: "ko_KR")

        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter
    }()

    /// name -> symbol
    /// KRW-BTC -> BTC
    static func nameToSymbol(_ name: String) -> String {
        let symbolStartIndex = name.index(name.startIndex, offsetBy: 4)
        return String(name[symbolStartIndex...])
    }

}
