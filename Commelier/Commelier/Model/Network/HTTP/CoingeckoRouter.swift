//
//  CoingeckoRouter.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation
import Alamofire

enum CoingeckoRouter: APIRouter {
    case getCoinInformation(vs_currency: String = "KRW", ids: String, sparkline: String = "true")
    case getTrending
    case getSearch(query: String)

    var environment: APIEnvironment {
        return .coingecko
    }

    var path: String {
        switch self {
        case .getCoinInformation:
            return "/coins/markets"
        case .getTrending:
            return "/search/trending"
        case .getSearch:
            return "/search"
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var parameters: Parameters {
        switch self {
        case .getCoinInformation(let vs_currency, let ids, let sparkline):
            return ["vs_currency": vs_currency, "ids": ids, "sparkline": sparkline]
        case .getTrending:
            return [:]
        case .getSearch(let query):
            return ["query": query]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getCoinInformation:
            return .get
        case .getTrending:
            return .get
        case .getSearch:
            return .get
        }
    }

    var encoding: URLEncoding {
        switch self {
        case .getCoinInformation:
            return .queryString
        case .getTrending:
            return .queryString
        case .getSearch:
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
