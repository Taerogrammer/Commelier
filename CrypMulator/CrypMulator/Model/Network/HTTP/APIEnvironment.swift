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
            return BaseURL.HTTPS.upbit
        case .coingecko:
            return BaseURL.HTTPS.coingecko
        }
    }
}
