//
//  ViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        view.backgroundColor = .blue
//        NetworkManager.shared.getItem(
//            api: UpbitRouter.getMarket(),
//            type: [UpbitMarketResponse].self) { result in
//                switch result {
//                case .success(let success):
//                    print("--> ", success)
//                case .failure(let failure):
//                    print("Error", failure)
//                }
//            }

//        NetworkManager.shared.getItem(
//            api: CoingeckoRouter.getCoinInformation(ids: "bitcoin"),
//            type: [CoingeckoCoinResponse].self) { result in
//                switch result {
//                case .success(let success):
//                    print("0-> ", success)
//                case .failure(let failure):
//                    print("error", failure)
//                }
//            }

//        NetworkManager.shared.getItem(
//            api: CoingeckoRouter.getTrending,
//            type: CoingeckoTrendingResponse.self) { result in
//                switch result {
//                case .success(let success):
//                    print("sucess", success)
//                case .failure(let failure):
//                    print("fail", failure)
//                }
//            }

//        NetworkManager.shared.getItem(
//            api: CoingeckoRouter.getSearch(query: "Bitcoin"),
//            type: CoingeckoSearchResponse.self) { result in
//                switch result {
//                case .success(let success):
//                    print("=-", success)
//                case .failure(let failure):
//                    print("error", failure)
//                }
//            }
    }
}
