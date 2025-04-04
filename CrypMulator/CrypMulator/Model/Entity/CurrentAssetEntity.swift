//
//  CurrentAssetEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 4/4/25.
//

import Foundation

/// Realm에서 불러오는 데이터
struct CurrentAssetEntity {
    /// 보유한 현금 (충전 + 매도 - 매수)
    let totalCurrency: Int64

    /// 보유 중인 코인들: [보유 목록]
    let totalCoin: [HoldingEntity]
}
