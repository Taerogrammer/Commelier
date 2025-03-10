//
//  TrendingViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import RxCocoa
import RxSwift
import Foundation

final class TrendingViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<APIError>()

    enum SettingAction {
        case navigateToDetail(String)
        case showAlert
    }

    struct Input {
        let searchBarTapped: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }

    struct Output {
        let action: Observable<SettingAction>
        let sectionResult: Observable<[TrendingSection]>
        let error: Observable<APIError>
    }

    func transform(input: Input) -> Output {
        let action = PublishSubject<SettingAction>()
        let result = PublishRelay<CoingeckoTrendingResponse>()
        LoadingIndicator.showLoading()
        NetworkManager.shared.getItem(
            api: CoingeckoRouter.getTrending,
            type: CoingeckoTrendingResponse.self)
        .subscribe(with: self) { owner, value in
            result.accept(value)
            LoadingIndicator.hideLoading()
        } onFailure: { owner, error in
            owner.error.accept(error as! APIError)
            LoadingIndicator.hideLoading()
        }
        .disposed(by: disposeBag)

        let sections = result
            .map { response -> [TrendingSection] in
                let coins = response.coins.map { coin in
                    TrendingItem.coins(TrendingCoin(
                        id: coin.item.id,
                        rank: "\(coin.item.score + 1)",
                        imageURL: coin.item.thumb,
                        symbol: coin.item.symbol,
                        name: coin.item.name,
                        rate: coin.item.data.price_change_percentage_24h.krw))
                }
                let nfts = response.nfts.map { nft in
                    TrendingItem.nfts(TrendingNFT(
                        imageURL: nft.thumb,
                        name: nft.name,
                        floorPrice: nft.data.floor_price,
                        floorPriceChange: nft.data.floor_price_in_usd_24h_percentage_change_description))
                }
                return [
                    TrendingSection(title: "인기 검색어", updated: .convertUpdateDate(date: Date()), items: coins),
                    TrendingSection(title: "인기 NFT", updated: nil, items: nfts)
                ]
            }

        input.searchBarTapped
            .withLatestFrom(input.searchText)
            .bind(with: self) { owner, text in
                action.onNext(text.count >= 2 ? SettingAction.navigateToDetail(text) : SettingAction.showAlert)
            }
            .disposed(by: disposeBag)

        return Output(action: action,
                      sectionResult: sections,
                      error: error.asObservable())
    }

    private func getData() {
        
    }

}
