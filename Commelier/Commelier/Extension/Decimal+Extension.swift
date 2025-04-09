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
}
