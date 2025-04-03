//
//  DecimalHelper.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Foundation
import RealmSwift

extension Decimal128 {
    func toDecimal() -> Decimal {
        self.decimalValue
    }

    static func toInt64(_ value: Decimal128) -> Int64 {
        let decimal = value.decimalValue
        return NSDecimalNumber(decimal: decimal).int64Value
    }
}

extension Decimal {
    static func + (lhs: Decimal, rhs: Decimal) -> Decimal {
        var result = Decimal()
        var lhs = lhs
        var rhs = rhs
        NSDecimalAdd(&result, &lhs, &rhs, .plain)
        return result
    }

    static func - (lhs: Decimal, rhs: Decimal) -> Decimal {
        var result = Decimal()
        var lhs = lhs
        var rhs = rhs
        NSDecimalSubtract(&result, &lhs, &rhs, .plain)
        return result
    }

    static func * (lhs: Decimal, rhs: Decimal) -> Decimal {
        var result = Decimal()
        var lhs = lhs
        var rhs = rhs
        NSDecimalMultiply(&result, &lhs, &rhs, .plain)
        return result
    }

    static func / (lhs: Decimal, rhs: Decimal) -> Decimal {
        var result = Decimal()
        var lhs = lhs
        var rhs = rhs
        NSDecimalDivide(&result, &lhs, &rhs, .plain)
        return result
    }

    static func += (lhs: inout Decimal, rhs: Decimal) {
        lhs = lhs + rhs
    }

    static func -= (lhs: inout Decimal, rhs: Decimal) {
        lhs = lhs - rhs
    }

    static func *= (lhs: inout Decimal, rhs: Decimal) {
        lhs = lhs * rhs
    }

    static func /= (lhs: inout Decimal, rhs: Decimal) {
        lhs = lhs / rhs
    }

    static func toNSDecimalNumber(_ decimal: Decimal) -> NSDecimalNumber {
        return NSDecimalNumber(decimal: decimal)
    }

    static func toDecimal128(_ decimal: Decimal) -> Decimal128 {
        return Decimal128(number: toNSDecimalNumber(decimal))
    }

    static func toInt64(_ decimal: Decimal) -> Int64 {
        return toNSDecimalNumber(decimal).int64Value
    }
}

extension Int64 {
    static func toDecimal(_ intValue: Int64) -> Decimal {
        return Decimal(intValue)
    }
}
