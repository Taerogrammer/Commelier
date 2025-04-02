//
//  TradeDTO.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import Foundation

struct TradeDTO {
    let market: String
    let buySell: String
    let transactionQuantity: Decimal
    let price: Decimal
    let timestamp: Int64
}
