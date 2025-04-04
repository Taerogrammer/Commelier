//
//  Int64+Extension.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
//

import Foundation

extension Int64 {
    var formattedWithComma: String {
        FormatUtility.decimalStyle.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    static func toDecimal(_ intValue: Int64) -> Decimal {
        return Decimal(intValue)
    }
}
