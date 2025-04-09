//
//  Decimal+Extension.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
//

import Foundation
import RealmSwift

extension Decimal {
    static func toNSDecimalNumber(_ decimal: Decimal) -> NSDecimalNumber {
        return NSDecimalNumber(decimal: decimal)
    }

    static func toDecimal128(_ decimal: Decimal) -> Decimal128 {
        return Decimal128(number: toNSDecimalNumber(decimal))
    }

//    static func toInt64(_ decimal: Decimal) -> Int64 {
//        return toNSDecimalNumber(decimal).int64Value
//    }

    func rounded(scale: Int, mode: NSDecimalNumber.RoundingMode) -> Decimal {
        var result = Decimal()
        var base = self
        NSDecimalRound(&result, &base, scale, mode)
        return result
    }

    func toInt64Rounded() -> Int64 {
        let rounded = self.rounded(scale: 0, mode: .plain)
        return NSDecimalNumber(decimal: rounded).int64Value
    }
}
