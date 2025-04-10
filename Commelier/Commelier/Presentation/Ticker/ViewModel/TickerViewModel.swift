//
//  TickerViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/25/25.
//

import RxCocoa
import RxSwift

final class TickerViewModel: ViewModel {

    enum Action {
        case navigateToSetting
    }

    let tickerListViewModel: TickerListViewModel
    let portfolioUseCase: PortfolioUseCaseProtocol
    let webSocket: WebSocketProvider

    private let disposeBag = DisposeBag()

    init(tickerListViewModel: TickerListViewModel,
         portfolioUseCase: PortfolioUseCaseProtocol,
         webSocket: WebSocketProvider) {
        self.tickerListViewModel = tickerListViewModel
        self.portfolioUseCase = portfolioUseCase
        self.webSocket = webSocket
    }

    struct Input {
        let listInput: TickerListViewModel.Input
        let settingButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let error: Observable<APIError>
        let selectedItem: Observable<UpbitMarketEntity>
        let settingButtonTapped: Observable<Action>
    }

    func transform(input: Input) -> Output {
        let listOutput = tickerListViewModel.transform(input: input.listInput)
        let settingButtonAction = PublishRelay<Action>()

        input.settingButtonTapped
            .subscribe(with: self) { owner, _ in
                settingButtonAction.accept(Action.navigateToSetting)
            }
            .disposed(by: disposeBag)

        return Output(error: tickerListViewModel.errorStream,
                      selectedItem: listOutput.selectedItem,
                      settingButtonTapped: settingButtonAction.asObservable())
    }
}
