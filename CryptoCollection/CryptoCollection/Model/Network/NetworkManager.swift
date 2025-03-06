//
//  NetworkManager.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()

    private init() { }

    func getItem<T: Decodable>(api: APIRouter,
                               type: T.Type,
                               completionHandler: @escaping (Result<T, Error>) -> Void) {
        AF.request(api)
            .validate(statusCode: 200...299)
            .cURLDescription { print($0) }
            .responseDecodable(of: T.self) { response in
                completionHandler(response.result.mapError { $0 as Error })
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
