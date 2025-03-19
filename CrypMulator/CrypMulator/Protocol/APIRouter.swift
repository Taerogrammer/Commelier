//
//  APIRouter.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation
import Alamofire

protocol APIRouter: URLRequestConvertible {
    var environment: APIEnvironment { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters { get }
    var method: HTTPMethod { get }
    var encoding: URLEncoding { get }
}
