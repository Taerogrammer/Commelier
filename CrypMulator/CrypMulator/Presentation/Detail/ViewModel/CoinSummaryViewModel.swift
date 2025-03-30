//
//  CoinSummaryViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Combine
import Foundation

final class CoinSummaryViewModel: ViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let webSocketManager = WebSocketManager.shared
    private let request: TickerDetailRequest

    // 외부에서 구독 가능한 ticker
    @Published private(set) var ticker: TickerEntity?

    init(request: TickerDetailRequest) {
        self.request = request
        connectWebSocket()
    }

    struct Input {

    }

    struct Output {
        let ticker: AnyPublisher<TickerEntity, Never>
    }

    func transform(input: Input) -> Output {
        let tickerStream = $ticker
            .compactMap { $0 }
            .eraseToAnyPublisher()

        return Output(ticker: tickerStream)
    }

    private func connectWebSocket() {
        webSocketManager.connect()
        webSocketManager.send(market: request.market)

        // TODO: - send()가 붙는지는 확인하기
        webSocketManager.tickerPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ticker in
                self?.ticker = ticker
            }
            .store(in: &cancellables)
    }

    deinit {
        webSocketManager.disconnect()
    }
}
