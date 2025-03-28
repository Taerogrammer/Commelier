//
//  FormatUtility.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import Foundation

enum FormatUtility {

    static func formatAmount(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "," // 명시적으로 지정
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    static func formatPercent(_ value: Double, fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)%"
    }

    static func formatCurrency(_ value: Double, currencySymbol: String = "₩") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let formatted = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        return "\(formatted) \(currencySymbol)"
    }
}
