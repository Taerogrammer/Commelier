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

    @Published private(set) var sections: [DetailSection] = []

    init(request: TickerDetailRequest, webSocket: WebSocketProvider) {
        self.request = request
        self.webSocket = webSocket
        bindWebSocket()
    }

    struct Input { }

    struct Output {
        let sections: AnyPublisher<[DetailSection], Never>
    }

    func transform(input: Input) -> Output {
        return Output(
            sections: $sections.eraseToAnyPublisher()
        )
    }

    private func bindWebSocket() {
        webSocket.symbolInfoPublisher
            .map { [$0.toDetailSection()] }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                self?.sections = sections
            }
            .store(in: &cancellables)
    }
}
