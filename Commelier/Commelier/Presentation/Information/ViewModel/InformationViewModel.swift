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
    private let holdingSectionRelay = BehaviorRelay<InformationSection>(
        value: InformationSection(title: StringLiteral.Information.holding, updated: nil, items: [])
    )

    private let repository: HoldingRepositoryProtocol

    init(repository: HoldingRepositoryProtocol) {
        self.repository = repository
    }

    struct Input { }

    struct Output {
        let sectionResult: Observable<[InformationSection]>
        let error: Observable<APIError>
    }

    func transform(input: Input) -> Output {
        getData()
        getDataByTimer()
        reloadHoldingSection() // 초기 로딩

        // 코인 트렌딩 스트림
        let coinsObservable = result.map { response -> [InformationItem] in
            return response.coins.map { coin in
                InformationItem.coins(CoinRankingViewData(
                    id: coin.item.id,
                    rank: "\(coin.item.score + 1)",
                    imageURL: coin.item.thumb,
                    symbol: coin.item.symbol,
                    name: coin.item.name,
                    rate: coin.item.data.price_change_percentage_24h.krw,
                    marketCapRank: coin.item.market_cap_rank,
                    marketCap: coin.item.data.market_cap,
                    totalVolume: coin.item.data.total_volume
                ))
            }
        }

        // 두 섹션을 combineLatest로 병합
        let sections = Observable.combineLatest(coinsObservable, holdingSectionRelay)
            .map { coins, holding in
                return [
                    InformationSection(title: StringLiteral.Information.popular, updated: .convertUpdateDate(date: Date()), items: coins),
                    holding
                ]
            }

        return Output(sectionResult: sections,
                      error: error.asObservable())
    }

    func reloadHoldingSection() {
        let holdings = repository.getHolding().map { $0.toEntity() }
        let items = holdings.map { InformationItem.holding($0) }
        let section = InformationSection(
            title: StringLiteral.Information.holding,
            updated: nil,
            items: items
        )
        holdingSectionRelay.accept(section)
    }

    func getData() {
        LoadingIndicator.showLoading()
        NetworkManager.shared.getItem(
            api: CoingeckoRouter.getTrending,
            type: CoingeckoTrendingResponse.self
        )
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
        let holdings: [HoldingEntity] = repository.getHolding().map { $0.toEntity() }

        let items: [InformationItem] = holdings.map { holding in
            return InformationItem.holding(holding)
        }

        return InformationSection(
            title: StringLiteral.Information.holding,
            updated: nil,
            items: items
        )
    }
}
