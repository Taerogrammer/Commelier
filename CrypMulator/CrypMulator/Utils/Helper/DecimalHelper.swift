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
}
