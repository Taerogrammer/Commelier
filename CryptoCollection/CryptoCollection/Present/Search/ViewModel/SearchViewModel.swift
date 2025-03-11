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
    private let error = PublishRelay<APIError>()

    enum SettingAction {
        case popViewController
    }

    struct Input {
        let searchBarTapped: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let barButtonTapped: ControlEvent<Void>
        let itemSelectedTapped: ControlEvent<IndexPath> 
    }

    struct Output {
        let action: PublishRelay<SettingAction>
        let data: Observable<[CoinData]>
        let error: Observable<APIError>
    }

    init(searchText: String) {
        self.searchText = Observable.just(searchText)
    }

    func transform(input: Input) -> Output {
        let action = PublishRelay<SettingAction>()
        let result = BehaviorRelay<[CoinData]>(value: [])

        input.searchBarTapped
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .flatMapLatest { query -> Single<CoingeckoSearchResponse> in
                LoadingIndicator.showLoading()
                return NetworkManager.shared.getItem(
                    api: CoingeckoRouter.getSearch(query: query),
                    type: CoingeckoSearchResponse.self)
            }
            .subscribe(with: self) { owner, data in
                result.accept(data.coins)
                LoadingIndicator.hideLoading()
            } onError: { [weak self] _, error in
                self?.error.accept(error as! APIError)
                LoadingIndicator.hideLoading()
            }
            .disposed(by: disposeBag)

        input.barButtonTapped
            .bind(with: self) { owner, _ in
                action.accept(SettingAction.popViewController)
            }
            .disposed(by: disposeBag)

        searchText
            .flatMapLatest { query -> Single<CoingeckoSearchResponse> in
                LoadingIndicator.showLoading()
                return NetworkManager.shared.getItem(
                    api: CoingeckoRouter.getSearch(query: query),
                    type: CoingeckoSearchResponse.self)
            }
            .subscribe(with: self) { owner, data in
                result.accept(data.coins)
                LoadingIndicator.hideLoading()
            } onError: { [weak self] _, error in
                self?.error.accept(error as! APIError)
                LoadingIndicator.hideLoading()
            }
            .disposed(by: disposeBag)

        return Output(
            action: action,
            data: result.asObservable(),
            error: error.asObservable())
    }
}
