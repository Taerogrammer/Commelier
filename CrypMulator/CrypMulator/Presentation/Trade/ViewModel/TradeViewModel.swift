//
//  TradeViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Combine
import Foundation

final class TradeViewModel: ViewModel {
    private let type: OrderType
    private var cancellables = Set<AnyCancellable>()
    private let webSocket: WebSocketProvider
    private let tradeUseCase: TradeUseCaseProtocol

    @Published private(set) var livePriceEntity: LivePriceEntity?
    @Published private(set) var availableCurrency: Decimal = 0
    @Published private(set) var inputAmount: Decimal = 0
    @Published private(set) var shouldShowWarning: Bool = false

    enum Action {
        case pop
        case tradeCompleted(success: Bool)
    }

    init(type: OrderType,
         webSocket: WebSocketProvider,
         tradeUseCase: TradeUseCaseProtocol) {
        self.type = type
        self.webSocket = webSocket
        self.tradeUseCase = tradeUseCase

        bindWebSocket()
        loadAvailableCurrency()
    }

    struct Input {
        let barButtonTapped: AnyPublisher<Void, Never>
        let numberInput: AnyPublisher<String, Never>
        let tradeButtonTapped: AnyPublisher<Void, Never>
    }

    struct Output {
        let action: AnyPublisher<Action, Never>
        let ticker: AnyPublisher<LivePriceEntity, Never>
        let availableCurrency: AnyPublisher<String, Never>
        let inputAmountText: AnyPublisher<String, Never>
        let shouldShowWarning: AnyPublisher<Bool, Never>
    }

    func transform(input: Input) -> Output {
        let barButtonAction = input.barButtonTapped
            .map { Action.pop }
            .eraseToAnyPublisher()

        let tradeButtonAction = input.tradeButtonTapped
            .map { [weak self] _ -> Action in
                let isSuccess = Bool.random() // 예시. 실제 거래 로직 결과 사용
                return .tradeCompleted(success: isSuccess)
            }
            .eraseToAnyPublisher()

        let actionStream = Publishers.Merge(barButtonAction, tradeButtonAction)
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

        return Output(action: actionStream,
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

    private func loadAvailableCurrency() {
        switch type {
        case .buy:
            self.availableCurrency = tradeUseCase.getCurrentCurrency()
        case .sell: break
//            self.availableCurrency = currentCurrencyUseCase.getCurrentCurrency()

        }
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
