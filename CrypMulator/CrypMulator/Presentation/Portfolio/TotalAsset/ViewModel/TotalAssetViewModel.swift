//
//  TotalAssetViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import Combine
import Foundation

final class TotalAssetViewModel: ViewModel {
    private let portfolioUseCase: PortfolioUseCaseProtocol
    private let webSocket: WebSocketProvider

    private var cancellables = Set<AnyCancellable>()
    private let actionPublisher = PassthroughSubject<Action, Never>()

    init(portfolioUseCase: PortfolioUseCaseProtocol,
         webSocket: WebSocketProvider) {
        self.portfolioUseCase = portfolioUseCase
        self.webSocket = webSocket

        let holdings = portfolioUseCase.getHoldings()
        let marketList = holdings.map { $0.name }

        print("📡 WebSocket Send for Markets:", marketList)

        webSocket.connect()
        webSocket.send(markets: marketList)

        print("==== Current Asset:", portfolioUseCase.getCurrentAssetEntity())
    }

    enum Action {
        case presentCharge
    }

    struct Input {
        let chargeButtonTapped: AnyPublisher<Void, Never>
    }

    struct Output {
        let action: AnyPublisher<Action, Never>
    }

    func transform(input: Input) -> Output {
        input.chargeButtonTapped
            .sink { [weak self] in
                self?.actionPublisher.send(.presentCharge)
            }
            .store(in: &cancellables)

        return Output(action: actionPublisher.eraseToAnyPublisher())
    }
}
