//
//  DetailViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import RxCocoa
import RxSwift

final class DetailViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let id: Observable<String>

    struct Input {

    }

    struct Output {
        let data: Observable<CoingeckoCoinResponse>
    }

    init(id: String) {
        self.id = Observable.just(id)
    }

    func transform(input: Input) -> Output {
        let result = PublishRelay<CoingeckoCoinResponse>()

        id
            .flatMapLatest { id -> Single<CoingeckoCoinResponse> in
                return NetworkManager.shared.getItem(
                    api: CoingeckoRouter.getCoinInformation(ids: id),
                    type: CoingeckoCoinResponse.self)
            }
            .bind(with: self) { owner, data in
                result.accept(data)
            }
            .disposed(by: disposeBag)

        return Output(data: result.asObservable())
    }
}
