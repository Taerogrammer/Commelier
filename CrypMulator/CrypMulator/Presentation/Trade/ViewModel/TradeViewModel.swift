//
//  TradeViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Combine
import Foundation

final class TradeViewModel: ViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let webSocket: WebSocketProvider

    @Published private(set) var livePriceEntity: LivePriceEntity?

    enum Action {
        case pop
    }

    init(webSocket: WebSocketProvider) {
        self.webSocket = webSocket
        bindWebSocket()
    }

    struct Input {
        let barButtonTapped: AnyPublisher<Void, Never>
    }

    struct Output {
        let action: AnyPublisher<Action, Never>
        let ticker: AnyPublisher<LivePriceEntity, Never>
    }

    func transform(input: Input) -> Output {
        let actionPublisher = input.barButtonTapped
            .map { Action.pop }
            .eraseToAnyPublisher()

        let tickerStream = $livePriceEntity
            .compactMap { $0 }
            .eraseToAnyPublisher()

        return Output(action: actionPublisher,
                      ticker: tickerStream)
    }

    private func bindWebSocket() {
        webSocket.livePricePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.livePriceEntity = $0 }
            .store(in: &cancellables)
    }
}
