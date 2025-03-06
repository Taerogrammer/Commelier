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
