//
//  UpbitTickerResponse.swift
//  Commelier
//
//  Created by 김태형 on 5/30/25.
//

import Foundation

struct UpbitTickerResponse: Decodable {
    let market: String
    let trade_price: Double
}
