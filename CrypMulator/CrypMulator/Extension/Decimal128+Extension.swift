//
//  Decimal128+Extension.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
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
