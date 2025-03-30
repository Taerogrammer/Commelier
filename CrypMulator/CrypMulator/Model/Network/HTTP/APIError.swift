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
    case decodingError   // DecodingError
    case notConnectedToInternet
    case networkConnectionLost
    case cannotConnectToHost
    case timedOut
    case unknownError

    var description: String {
        switch self {
        case .badRequest:
            "잘못된 요청입니다. 다시 한 번 시도해주세요."
        case .unauthorized:
            "권한이 존재하지 않습니다. 다시 한 번 시도해주세요."
        case .notFound:
            "존재하지 않는 페이지입니다. 다시 한 번 시도해주세요."
        case .tooManyRequest:
            "과도한 네트워크 요청으로 중단되었습니다. 잠시 후 다시 시도해주세요."
        case .decodingError:
            "알 수 없는 오류가 발생하였습니다. 다시 한 번 시도해주세요. (디코딩 에러)"
        case .notConnectedToInternet:
            "인터넷 연결되어 있지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요."
        case .networkConnectionLost:
            "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요."
        case .cannotConnectToHost:
            "호스트 연결이 끊겼습니다. 다시 한 번 시도해주세요."
        case .timedOut:
            "요청 시간이 초과하였습니다. 데이터 또는 Wi-Fi 연경 상태를 확인해주세요."
        case .unknownError:
            "알 수 없는 오류가 발생하였습니다. 다시 한 번 시도해주세요."
        }
    }
}
