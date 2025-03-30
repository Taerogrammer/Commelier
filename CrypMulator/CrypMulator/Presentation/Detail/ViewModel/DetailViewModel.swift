//
//  DetailViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import RxCocoa
import RxSwift

final class DetailViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let request: TickerDetailRequest

    init(request: TickerDetailRequest) {
        self.request = request
        print("request ==> ", request)
    }

    struct Input {
    }

    struct Output {
        let chartEntity: PublishRelay<[ChartEntity]>
    }

    func transform(input: Input) -> Output {
        let chartRelay = PublishRelay<[ChartEntity]>()

        Observable.just(request.market)
            .flatMapLatest { query -> Single<[UpbitDailyCandleResponse]> in
                LoadingIndicator.showLoading()
                return NetworkManager.shared.getItem(
                    api: UpbitRouter.getCandleDay(market: query),
                    type: [UpbitDailyCandleResponse].self)
            }
            .subscribe(with: self) { owner, response in
                let chart: [ChartEntity] = response.map {
                    $0.toEntity()
                }
                chartRelay.accept(chart)
                LoadingIndicator.hideLoading()
            } onError: { owner, error in
                print("error", error)
            }
            .disposed(by: disposeBag)

        return Output(chartEntity: chartRelay)
    }
}
