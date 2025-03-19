//
//  APIEnvironment.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation

enum APIEnvironment {
    case upbit
    case coingecko

    var baseURL: String {
        switch self {
        case .upbit:
            return "https://api.upbit.com/v1/ticker"
        case .coingecko:
            return "https://api.coingecko.com/api/v3"
        }
    }
}
