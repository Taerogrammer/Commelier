//
//  CoinSummaryViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Combine
import Foundation

final class CoinLivePriceViewModel: ViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let webSocket: WebSocketProvider
    private let request: TickerDetailRequest

    @Published private(set) var livePriceEntity: LivePriceEntity?

    init(request: TickerDetailRequest, webSocket: WebSocketProvider) {
        self.request = request
        self.webSocket = webSocket
        bindWebSocket() // ✅ 연결은 없음
    }

    struct Input { }

    struct Output {
        let ticker: AnyPublisher<LivePriceEntity, Never>
    }

    func transform(input: Input) -> Output {
        let tickerStream = $livePriceEntity
            .compactMap { $0 }
            .eraseToAnyPublisher()

        return Output(ticker: tickerStream)
    }

    private func bindWebSocket() {
        webSocket.livePricePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.livePriceEntity = $0 }
            .store(in: &cancellables)
    }
}
