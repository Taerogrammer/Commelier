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
                .cURLDescription { print($0) }
                .responseDecodable(of: T.self) { response in
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 200...299: // 성공
                            switch response.result {
                            case .success(let data):
                                value(.success(data))
                            case .failure:
                                value(.failure(APIError.unknownError))
                            }
                        case 400:
                            print("400")
                            value(.failure(APIError.badRequest))
                        case 401:
                            print("401")
                            value(.failure(APIError.unauthorized))
                        case 404:
                            print("404")
                            value(.failure(APIError.notFound))
                        default:
                            value(.failure(APIError.networkError))
                        }
                    }
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
