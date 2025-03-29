//
//  CoinMetaEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import Foundation

struct CoinMetaEntity {
    let marketCap: Double                    // 시가 총액
    let marketCapRank: Int                   // 시총 순위
    let fullyDilutedValuation: Double        // 완전 희석 가치
    let circulatingSupply: Double            // 유통량
    let totalSupply: Double                  // 총 공급량
    let maxSupply: Double                    // 최대 공급량
    let ath: Double                          // 역대 최고가
    let athDate: String                      // 최고가 달성일
    let atl: Double                          // 역대 최저가
    let atlDate: String                      // 최저가 달성일
    let lastUpdated: String                  // 최근 업데이트 시각
}
