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
    private let webSocket: WebSocketProvider

    enum Action {
        case pop
    }

    init(request: TickerDetailRequest, webSocket: WebSocketProvider) {
        self.request = request
        self.webSocket = webSocket
    }

    struct Input {
        let barButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let chartEntity: PublishRelay<[ChartEntity]>
        let action: PublishRelay<Action>
    }

    func transform(input: Input) -> Output {
        let chartRelay = PublishRelay<[ChartEntity]>()
        let action = PublishRelay<Action>()

        webSocket.send(market: request.market)

        input.barButtonTapped
            .bind(with: self) { owner, _ in
                action.accept(Action.pop)
            }
            .disposed(by: disposeBag)

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

        return Output(chartEntity: chartRelay,
                      action: action)
    }
}
