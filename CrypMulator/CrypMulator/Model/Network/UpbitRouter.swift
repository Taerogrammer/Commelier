//
//  UpbitRouter.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation
import Alamofire

enum UpbitRouter: APIRouter {

    /// Ticker
    case getMarket(quote_currencies: String = "KRW")

    /// Detail
    case getCandleDay(market: String, count: Int = 200)

    var environment: APIEnvironment {
        return .upbit
    }

    var path: String {
        switch self {
        case .getMarket:
            return "/ticker/all"
        case .getCandleDay:
            return "/candles/days"
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var parameters: Parameters {
        switch self {
        case .getMarket(let quote_currencies):
            return ["quote_currencies": quote_currencies]
        case .getCandleDay(market: let market, count: let count):
            return ["market": market, "count": count]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getMarket:
            return .get
        case .getCandleDay:
            return .get
        }
    }

    var encoding: URLEncoding {
        switch self {
        case .getMarket:
            return .queryString
        case .getCandleDay:
            return .queryString
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try environment.baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        return try encoding.encode(request, with: parameters)
    }
}
