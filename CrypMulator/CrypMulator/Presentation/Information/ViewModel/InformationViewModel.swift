//
//  TrendingViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import Foundation
import RxCocoa
import RxSwift

final class InformationViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<APIError>()
    private var disposable: Disposable?
    let result = PublishRelay<CoingeckoTrendingResponse>()
    private let repository: OldFavoriteCoinRepositoryProtocol

    init(repository: OldFavoriteCoinRepositoryProtocol) {
        self.repository = repository
    }

    struct Input {
    }

    struct Output {
        let sectionResult: Observable<[InformationSection]>
        let error: Observable<APIError>
    }

    func transform(input: Input) -> Output {
        getData()
        getDataByTimer()

        let sections = result
            .map { response -> [InformationSection] in
                let coins = response.coins.map { coin in
                    InformationItem.coins(CoinRankingViewData(
                        id: coin.item.id,
                        rank: "\(coin.item.score + 1)",
                        imageURL: coin.item.thumb,
                        symbol: coin.item.symbol,
                        name: coin.item.name,
                        rate: coin.item.data.price_change_percentage_24h.krw))
                }

                let favoriteSection = self.loadFavoriteSection()

                return [
                    InformationSection(title: StringLiteral.Information.popular, updated: .convertUpdateDate(date: Date()), items: coins), favoriteSection
                ]
            }

        return Output(sectionResult: sections,
                      error: error.asObservable())
    }

    private func getData() {
        LoadingIndicator.showLoading()
        NetworkManager.shared.getItem(
            api: CoingeckoRouter.getTrending,
            type: CoingeckoTrendingResponse.self)
        .subscribe(with: self) { owner, value in
            owner.result.accept(value)
            LoadingIndicator.hideLoading()
        } onFailure: { owner, error in
            owner.error.accept(error as! APIError)
            LoadingIndicator.hideLoading()
        }
        .disposed(by: disposeBag)
    }

    func getDataByTimer() {
        disposeTimer()
        disposable = Observable<Int>.interval(.seconds(600), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(with: self, onNext: { owner, sec in
                owner.getData()
            })
    }

    func disposeTimer() {
        disposable?.dispose()
    }

    private func loadFavoriteSection() -> InformationSection {
        let favorites = repository.getAll()
        let items = favorites.map { InformationItem.favorite($0) }

        return InformationSection(
            title: StringLiteral.Information.favorite,
            updated: nil,
            items: Array(items)
        )
    }
}
