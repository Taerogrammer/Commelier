//
//  UpbitRouter.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation
import Alamofire

enum UpbitRouter: APIRouter {

    case getMarket(quote_currencies: String = "KRW")

    var environment: APIEnvironment {
        return .upbit
    }

    var path: String {
        switch self {
        case .getMarket:
            return "/all"
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var parameters: Parameters {
        switch self {
        case .getMarket(let quote_currencies):
            return ["quote_currencies": quote_currencies]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getMarket:
            return .get
        }
    }

    var encoding: URLEncoding {
        switch self {
        case .getMarket:
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
