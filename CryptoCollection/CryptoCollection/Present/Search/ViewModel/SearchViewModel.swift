//
//  SearchViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

final class SearchViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private var searchText: Observable<String>
//    private let favoriteCoinRepository = FavoriteCoinRepository()

    enum SettingAction {
        case popViewController
    }

    struct Input {
        let searchBarTapped: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let barButtonTapped: ControlEvent<Void>
        let itemSelectedTapped: ControlEvent<IndexPath>
//        let favoriteButtonTapped: PublishSubject<CoinData>
    }

    struct Output {
        let action: PublishRelay<SettingAction>
        let data: Observable<[CoinData]>
    }

    init(searchText: String) {
        self.searchText = Observable.just(searchText)
    }

    func transform(input: Input) -> Output {
        let action = PublishRelay<SettingAction>()
        let result = BehaviorRelay<[CoinData]>(value: [])

        input.searchBarTapped
            .withLatestFrom(input.searchText)
            .flatMapLatest { query -> Single<CoingeckoSearchResponse> in
                return NetworkManager.shared.getItem(
                    api: CoingeckoRouter.getSearch(query: query),
                    type: CoingeckoSearchResponse.self)
            }
            .subscribe(with: self) { owner, data in
                result.accept(data.coins)
            }
            .disposed(by: disposeBag)

        input.barButtonTapped
            .bind(with: self) { owner, _ in
                action.accept(SettingAction.popViewController)
            }
            .disposed(by: disposeBag)

        searchText
            .flatMapLatest { query -> Single<CoingeckoSearchResponse> in
                return NetworkManager.shared.getItem(
                    api: CoingeckoRouter.getSearch(query: query),
                    type: CoingeckoSearchResponse.self)
            }
            .subscribe(with: self) { owner, data in
                result.accept(data.coins)
            }
            .disposed(by: disposeBag)

        input.itemSelectedTapped
            .bind(with: self) { owner, indexPath in
                print("indexPath", indexPath)

            }
            .disposed(by: disposeBag)

        return Output(
            action: action,
            data: result.asObservable())
    }
}
