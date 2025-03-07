//
//  UpbitMarketResponse.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation

let million: Double = 1_000_000
enum change {
    case EVEN

}

struct UpbitMarketResponse: Decodable {
    let market: String
    let trade_price: Double
    let change: String
    let signed_change_price: Double
    let signed_change_rate: Double
    let acc_trade_price_24h: Double


    var trade_price_description: String {
        return numberConverter(number: trade_price)
    }

    var signed_change_price_description: String {
        return numberConverter(number: signed_change_price)
    }

    var signed_change_rate_description: String {
        return numberConverter(number: signed_change_rate) + "%"
    }

    var acc_trade_price_24h_description: String {
        return Int((acc_trade_price_24h / million)).formatted() + "백만"
    }
}

// TODO: 숫자 변환
/*
 세자리 쉼표
 소수점 2자리까지 표시
 값 상승: 빨간색 (+, 세모)
 값 하락: 파랑색 (-, 세모)
 값 유지: 검정색 ()


 반올림 했을 때 0이라도 -가 나타날 수 있음
 
 */

func numberConverter(number: Double) -> String {

    return (round(number * 100) / 100).formatted()
}
