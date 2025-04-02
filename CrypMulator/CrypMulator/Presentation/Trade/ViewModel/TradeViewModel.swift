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
    private let currentCurrencyUseCase: CurrentCurrencyUseCaseProtocol

    @Published private(set) var livePriceEntity: LivePriceEntity?
    @Published private(set) var availableCurrency: Decimal = 0
    @Published private(set) var inputAmount: Decimal = 0

    enum Action {
        case pop
    }

    init(webSocket: WebSocketProvider,
         currentCurrencyUseCase: CurrentCurrencyUseCaseProtocol) {
        self.webSocket = webSocket
        self.currentCurrencyUseCase = currentCurrencyUseCase

        bindWebSocket()
        loadAvailableKRW()
    }

    struct Input {
        let barButtonTapped: AnyPublisher<Void, Never>
        let numberInput: AnyPublisher<String, Never>
    }

    struct Output {
        let action: AnyPublisher<Action, Never>
        let ticker: AnyPublisher<LivePriceEntity, Never>
        let availableCurrency: AnyPublisher<String, Never>
        let inputAmountText: AnyPublisher<String, Never>
    }

    func transform(input: Input) -> Output {
        let actionPublisher = input.barButtonTapped
            .map { Action.pop }
            .eraseToAnyPublisher()

        input.numberInput
            .sink { [weak self] value in
                self?.handleInput(value)
            }
            .store(in: &cancellables)


        let tickerStream = $livePriceEntity
            .compactMap { $0 }
            .eraseToAnyPublisher()

        let availableCurrencyStream = $availableCurrency
            .map { FormatUtility.decimalToString($0) }
            .eraseToAnyPublisher()
        

        let inputAmountStream = $inputAmount
            .map { FormatUtility.decimalToString($0) }
            .eraseToAnyPublisher()

        return Output(action: actionPublisher,
                      ticker: tickerStream,
                      availableCurrency: availableCurrencyStream,
                      inputAmountText: inputAmountStream)
    }

    private func bindWebSocket() {
        webSocket.livePricePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.livePriceEntity = $0 }
            .store(in: &cancellables)
    }

    private func loadAvailableKRW() {
        self.availableCurrency = currentCurrencyUseCase.getCurrentCurrency()
    }

    private func handleInput(_ value: String) {
        switch value {
        case "←":
            var string = inputAmount.description
            string = String(string.dropLast())
            inputAmount = Decimal(string: string.isEmpty ? "0" : string) ?? 0

        default:
            let nextString = (inputAmount == 0 ? value : inputAmount.description + value)
            let nextDecimal = Decimal(string: nextString) ?? 0

            if nextDecimal <= availableCurrency {
                inputAmount = nextDecimal
            }
        }
    }
}
