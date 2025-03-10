//
//  NetworkManager.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()

    private init() { }

    func getItem<T: Decodable>(api: APIRouter, type: T.Type) -> Single<T> {
        return Single.create { value in
            AF.request(api)
                .validate(statusCode: 200...299)
//                .cURLDescription { print($0) }
                .responseDecodable(of: T.self) { response in
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 200...299: // 성공
                            switch response.result {
                            case .success(let data):
                                value(.success(data))
                            case .failure(let error):
                                print("failed with 200", error)
                                value(.failure(APIError.decodingError))
                            }
                        case 400:
                            value(.failure(APIError.badRequest))
                        case 401:
                            value(.failure(APIError.unauthorized))
                        case 404:
                            value(.failure(APIError.notFound))
                        case 429:
                            value(.failure(APIError.tooManyRequest))
                        default:
                            value(.failure(APIError.unknownError))
                        }
                    } else if let error = response.error {
                        if let underlyingError = error.underlyingError {
                            if let urlError = underlyingError as? URLError {
                                switch urlError.code {
                                case .notConnectedToInternet:
                                    print("notConnectedToInternet")
                                    value(.failure(APIError.notConnectedToInternet))
                                case .networkConnectionLost:
                                    print("networkConnectionLost")
                                    value(.failure(APIError.networkConnectionLost))
                                case .cannotConnectToHost:
                                    print("cannotConnectToHost")
                                    value(.failure(APIError.cannotConnectToHost))
                                case .timedOut:
                                    print("timedOut")
                                    value(.failure(APIError.timedOut))
                                default:
                                    print("DEFAULT")
                                    value(.failure(APIError.unknownError))
                                }
                            }
                        }
                    }
//                    debugPrint(response.result)
                }
            return Disposables.create {
                print("끝")
            }
        }
    }
}

// MARK: - 예시
//NetworkManager.shared.getItem(
//    api: UpbitRouter.getMarket(),
//    type: [UpbitMarketResponse].self) { result in
//        switch result {
//        case .success(let success):
//            print("--> ", success)
//        case .failure(let failure):
//            print("Error", failure)
//        }
//    }
//
//NetworkManager.shared.getItem(
//    api: CoingeckoRouter.getCoinInformation(ids: "bitcoin"),
//    type: [CoingeckoCoinResponse].self) { result in
//        switch result {
//        case .success(let success):
//            print("0-> ", success)
//        case .failure(let failure):
//            print("error", failure)
//        }
//    }
//
//NetworkManager.shared.getItem(
//    api: CoingeckoRouter.getTrending,
//    type: CoingeckoTrendingResponse.self) { result in
//        switch result {
//        case .success(let success):
//            print("sucess", success)
//        case .failure(let failure):
//            print("fail", failure)
//        }
//    }
//
//NetworkManager.shared.getItem(
//    api: CoingeckoRouter.getSearch(query: "Bitcoin"),
//    type: CoingeckoSearchResponse.self) { result in
//        switch result {
//        case .success(let success):
//            print("=-", success)
//        case .failure(let failure):
//            print("error", failure)
//        }
//    }
