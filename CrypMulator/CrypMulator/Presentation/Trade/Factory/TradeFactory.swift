//
//  TradeFactory.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Foundation

struct TradeFactory {
    static func make(with market: String, type: OrderType) -> TradeViewController {


        return TradeViewController(type: type)
    }
}
