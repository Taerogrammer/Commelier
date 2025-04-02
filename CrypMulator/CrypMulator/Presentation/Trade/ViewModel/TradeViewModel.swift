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
    @Published private(set) var shouldShowWarning: Bool = false

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
        let shouldShowWarning: AnyPublisher<Bool, Never>
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

        let warningStream = $shouldShowWarning
            .removeDuplicates()
            .eraseToAnyPublisher()

        return Output(action: actionPublisher,
                      ticker: tickerStream,
                      availableCurrency: availableCurrencyStream,
                      inputAmountText: inputAmountStream,
                      shouldShowWarning: warningStream)
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
        var string = inputAmount.description

        switch value {
        case "←":
            string = String(string.dropLast())
            if string.isEmpty {
                string = "0"
            }

        default:
            string = (inputAmount == 0) ? value : string + value
        }
        let nextAmount = Decimal(string: string) ?? 0

        if nextAmount > availableCurrency {
            shouldShowWarning = true
            inputAmount = availableCurrency
        } else {
            shouldShowWarning = false
            inputAmount = nextAmount
        }
    }
}
