//
//  TotalAssetViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import RxSwift
import RxCocoa

final class TotalAssetViewModel: ViewModel {
    private let portfolioUseCase: PortfolioUseCaseProtocol

    private let disposeBag = DisposeBag()

    enum Action {
        case presentCharge
    }

    init(portfolioUseCase: PortfolioUseCaseProtocol) {
        self.portfolioUseCase = portfolioUseCase
    }

    struct Input {
        let chargeButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let action: Signal<Action>
    }

    func transform(input: Input) -> Output {
        let actionRelay = PublishRelay<Action>()

        input.chargeButtonTapped
            .bind(with: self) { owner, _ in
                actionRelay.accept(Action.presentCharge)
            }
            .disposed(by: disposeBag)

        return Output(action: actionRelay.asSignal(onErrorSignalWith: .empty()))
    }

}
