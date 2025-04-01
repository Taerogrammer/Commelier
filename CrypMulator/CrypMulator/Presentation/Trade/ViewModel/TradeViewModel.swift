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


    enum Action {
        case pop
    }

    init(webSocket: WebSocketProvider) {
        self.webSocket = webSocket
    }

    struct Input {
        let barButtonTapped: AnyPublisher<Void, Never>
    }

    struct Output {
        let action: AnyPublisher<Action, Never>
    }

    func transform(input: Input) -> Output {
        let actionPublisher = input.barButtonTapped
            .map { Action.pop }
            .eraseToAnyPublisher()

        return Output(action: actionPublisher)
    }
}
