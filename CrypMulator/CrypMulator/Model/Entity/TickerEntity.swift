//
//  TickerEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Foundation

struct TickerEntity {
    let market: String  // 이름
    let price: Double   // 현재 가격
    let change: String  // 변동 여부
    let signedChangeRate: Double  // 변동률 (부호 포함)
    let signedChangePrice: Double // 변동가격 (부호 포함)
    let priceChangeState: PriceChangeState  // 변화 상태
}
