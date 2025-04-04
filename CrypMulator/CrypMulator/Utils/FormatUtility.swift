//
//  FormatUtility.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import Foundation

enum FormatUtility {

    static func decimalToString(_ decimal: Decimal, fractionDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = fractionDigits
        formatter.minimumFractionDigits = fractionDigits
        formatter.groupingSeparator = ","

        let nsNumber = NSDecimalNumber(decimal: decimal)
        return formatter.string(from: nsNumber) ?? "\(decimal)"
    }

    static func decimalToFullString(_ decimal: Decimal) -> String {
        return NSDecimalNumber(decimal: decimal).stringValue
    }

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

    static func numberConverter(number: Double, style: NumberFormatter.Style = .decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale(identifier: "ko_KR")

        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    static func rateConverter(number: Double) -> String {
        return round(number * 100) / 100 == 0.00 ? "0.00" : String(format: "%.2f", (round(number * 100) / 100))
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter
    }()

    static func formattedPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }

    static func formattedPercent(_ value: Double) -> String {
        return String(format: "%.2f%", value * 100)
    }

    static func formattedVolume(_ value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value: value)) ?? "-"
    }

    /// name -> symbol
    /// KRW-BTC -> BTC
    static func nameToSymbol(_ name: String) -> String {
        let symbolStartIndex = name.index(name.startIndex, offsetBy: 4)
        return String(name[symbolStartIndex...])
    }

    static let decimalStyle: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
}
