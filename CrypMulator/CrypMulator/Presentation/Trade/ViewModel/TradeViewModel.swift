//
//  TradeViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Foundation

final class TradeViewModel: ViewModel {

    private let webSocket: WebSocketProvider

    init(webSocket: WebSocketProvider) {
        self.webSocket = webSocket
    }

    struct Input {

    }

    struct Output {

    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
