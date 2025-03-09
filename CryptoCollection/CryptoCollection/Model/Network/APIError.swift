//
//  APIError.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation

enum APIError: Error {
    case badRequest // 400
    case unauthorized   // 401
    case notFound   // 404
    case tooManyRequest   // 429
    case networkError   // TODO: 확인
    case decodingError   // DecodingError
}
