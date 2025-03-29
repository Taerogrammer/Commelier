//
//  RealtimeCoinEntity.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import UIKit

struct RealtimeCoinEntity {
    let imageUrl: String                    // 이미지 url
    let name: String                        // 코인 이름
    let currentPrice: Double                // 현재가
    let signedChangePrice: Double           // 전일 대비 변동 금액
    let signedChangeRate: Double            // 전일 대비 변동률 (단위: 0.009 → 0.9%)
    let changeState: PriceChangeState       // 상승/하락/보합

    var formattedPrice: String {
        FormatUtility.numberConverter(number: currentPrice, style: .currency)
    }

    var formattedChangePrice: String {
        let formatted = FormatUtility.numberConverter(number: abs(signedChangePrice), style: .decimal)
        return "\(changeState.symbol)\(formatted)"
    }

    var formattedChangeRate: String {
        let formatted = FormatUtility.rateConverter(number: abs(signedChangeRate * 100))
        return "\(changeState.symbol)\(formatted)%"
    }

    var changeColor: UIColor {
        changeState.color
    }

    var isPositive: Bool {
        signedChangePrice > 0
    }
}
