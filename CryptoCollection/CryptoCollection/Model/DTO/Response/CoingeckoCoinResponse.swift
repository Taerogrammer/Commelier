//
//  CoingeckoCoinResponse.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation

struct CoingeckoCoinResponse: Decodable {
    let id: String
    let symbol: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Double
    let sparkline_in_7d: Price
    let last_updated: String
    let high_24h: Double
    let low_24h: Double
    let ath: Double
    let ath_date: String
    let atl: Double
    let atl_date: String
    let market_cap: Double
    let fully_diluted_valuation: Double
    let total_volume: Double

    var current_price_description: String {
        return "￦" + current_price.formatted()
    }
    // TODO: 구현 필요
    var price_change_percentage_24h_description: String {
        return "100%"
    }
    // TODO: 구현 필요
    var last_updated_description: String {
        return ""
    }
    var high_24h_description: String {
        return "￦" + high_24h.formatted()
    }
    var low_24h_description: String {
        return "￦" + low_24h.formatted()
    }
    var ath_description: String {
        return "￦" + ath.formatted()
    }
    var ath_date_description: String {
        return String.convertDate(date: ath_date)
    }
    var atl_description: String {
        return "￦" + atl.formatted()
    }
    var atl_date_description: String {
        return String.convertDate(date: atl_date)
    }
    var market_cap_description: String {
        return "￦" + market_cap.formatted()
    }
    var fully_diluted_valuation_description: String {
        return "￦" + fully_diluted_valuation.formatted()
    }
    var total_volume_description: String {
        return "￦" + total_volume.formatted()
    }
}

struct Price: Decodable {
    let price: [Double]
}

