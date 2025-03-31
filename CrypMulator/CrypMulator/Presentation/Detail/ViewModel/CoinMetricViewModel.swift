//
//  CoinMetricViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/31/25.
//

import Combine
import Foundation

final class CoinMetricViewModel: ViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let webSocket: WebSocketProvider
    private let request: TickerDetailRequest

    @Published private(set) var symbolInfoEntity: SymbolInfoEntity?

    init(request: TickerDetailRequest, webSocket: WebSocketProvider) {
        self.request = request
        self.webSocket = webSocket
        bindWebSocket()
    }

    struct Input { }

    struct Output {
        let ticker: AnyPublisher<SymbolInfoEntity, Never>
    }

    func transform(input: Input) -> Output {
        let tickerStream = $symbolInfoEntity
            .compactMap { $0 }
            .eraseToAnyPublisher()

        return Output(ticker: tickerStream)
    }

    private func bindWebSocket() {
        webSocket.symbolInfoPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.symbolInfoEntity = $0 }
            .store(in: &cancellables)
    }
}
