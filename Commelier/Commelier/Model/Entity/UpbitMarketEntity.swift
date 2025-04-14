//
//  UpbitMarketEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import Foundation
import NumberterKit

struct UpbitMarketEntity {
    let market: String
    let trade_price: Double
    let change: String
    let signed_change_price: Double
    let signed_change_rate: Double
    let acc_trade_price_24h: Double

    var trade_price_description: String {
        return FormatUtility.numberConverter(number: trade_price)
    }

    var signed_change_price_description: String {
        return FormatUtility.numberConverter(number: signed_change_price)
    }

    var signed_change_rate_description: String {
        return signed_change_rate.percentString()
    }

    var acc_trade_price_24h_description: String {
        return Int((acc_trade_price_24h / million)).formatted() + "백만"
    }
}
