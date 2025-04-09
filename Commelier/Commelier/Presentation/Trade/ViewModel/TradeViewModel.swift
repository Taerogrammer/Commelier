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
    private let name: String
    private var inputString: String = "0"

    @Published private(set) var livePriceEntity: LivePriceEntity?
    @Published private(set) var availableCurrency: Decimal = 0
    @Published private(set) var totalQuantity: Decimal = 0
    @Published private(set) var inputAmount: Decimal = 0
    @Published private(set) var shouldShowWarning: Bool = false

    enum Action {
        case pop
        case tradeCompleted(success: Bool)
    }

    init(type: OrderType,
         name: String,
         webSocket: WebSocketProvider,
         tradeUseCase: TradeUseCaseProtocol) {
        self.type = type
        self.name = name
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
        let totalQuantity: AnyPublisher<String, Never>
        let inputAmountText: AnyPublisher<String, Never>
        let shouldShowWarning: AnyPublisher<Bool, Never>
        let isLivePriceLoaded: AnyPublisher<Bool, Never>
        let isTradeButtonEnabled: AnyPublisher<Bool, Never>
    }

    func transform(input: Input) -> Output {
        let barButtonAction = input.barButtonTapped
            .map { Action.pop }
            .eraseToAnyPublisher()

        let tradeButtonAction = input.tradeButtonTapped
            .map { [weak self] _ -> Action in
                // TODO: - 여기
                let isSuccess = self?.tradeClicked(price: self?.inputAmount.int64Value ?? 0)
                return .tradeCompleted(success: isSuccess ?? false)
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

        let totalQuantityStream = $totalQuantity
            .map { FormatUtility.decimalToFullString($0) }
            .eraseToAnyPublisher()

        let inputAmountStream = $inputAmount
            .map { FormatUtility.decimalToString($0) }
            .eraseToAnyPublisher()

        let warningStream = $shouldShowWarning
            .removeDuplicates()
            .eraseToAnyPublisher()

        let isLivePriceLoaded = $livePriceEntity
            .map { $0 != nil }
            .removeDuplicates()
            .eraseToAnyPublisher()

        let isCurrencyAvailable = $availableCurrency
            .map { $0 > 0 }
            .removeDuplicates()
            .eraseToAnyPublisher()

        let isInputAmountValid = $inputAmount
            .map { $0 > 0 }
            .removeDuplicates()

        let isTradeButtonEnabled = Publishers.CombineLatest3(
            isLivePriceLoaded,
            isCurrencyAvailable,
            isInputAmountValid
        )
        .map { isLoaded, hasCurrency, hasInput in
            return isLoaded && hasCurrency && hasInput
        }
        .removeDuplicates()
        .eraseToAnyPublisher()

        return Output(action: actionStream,
                      ticker: tickerStream,
                      availableCurrency: availableCurrencyStream,
                      totalQuantity: totalQuantityStream,
                      inputAmountText: inputAmountStream,
                      shouldShowWarning: warningStream,
                      isLivePriceLoaded: isLivePriceLoaded.eraseToAnyPublisher(), isTradeButtonEnabled: isTradeButtonEnabled)
    }

    private func bindWebSocket() {
        webSocket.livePricePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] entity in
                self?.livePriceEntity = entity
                self?.updateAvailableCurrencyIfNeeded()
                self?.updateTotalQuantityIfNeeded()
                /// 평가손익, 수익률
                self?.printProfitInfoIfNeeded()
            }
            .store(in: &cancellables)
    }

    private func updateAvailableCurrencyIfNeeded() {
        guard type == .sell,
              let livePrice = livePriceEntity?.price else { return }

        let holdingQuantity = tradeUseCase.getHoldingQuantity(of: name)
        availableCurrency = Decimal(livePrice) * holdingQuantity
    }

    private func updateTotalQuantityIfNeeded() {
        guard let livePrice = livePriceEntity?.price else { return }
        totalQuantity = inputAmount / Decimal(livePrice)
    }

    // TODO: - 평가손익이 0일 때 파랑색인 경우 존재
    private func printProfitInfoIfNeeded() {
        guard let livePrice = livePriceEntity?.price else { return }
        if let holding = tradeUseCase.getHoldingMarket(name: name) {
            let quantity = holding.transactionQuantity
            let totalBuyPrice = holding.totalBuyPrice

            let profit = Calculator.profitAmount(
                transactionQuantity: quantity,
                totalBuyPrice: totalBuyPrice,
                currentPrice: Decimal(livePrice)
            )

            let ratio = Calculator.profitRatio(
                transactionQuantity: quantity,
                totalBuyPrice: totalBuyPrice,
                currentPrice: Decimal(livePrice)
            )
            print("💰 평가손익: \(profit)")
            print("📈 수익률: \(ratio)%")
        }
    }

    private func loadAvailableCurrency() {
        switch type {
        case .buy:
            self.availableCurrency = Decimal(tradeUseCase.getCurrentCurrency())
        case .sell:
            self.availableCurrency = Decimal(tradeUseCase.getHoldingAmount(of: name))
        }
    }

    private func handleInput(_ value: String) {
        switch value {
        case "←":
            inputString = String(inputString.dropLast())
            if inputString.isEmpty {
                inputString = "0"
            }

        default:
            inputString = (inputString == "0") ? value : inputString + value
        }

        let nextAmount = Int64(inputString) ?? 0
        let maxAmountDecimal = availableCurrency.rounded(scale: 0, mode: .down)
        let maxAmount = NSDecimalNumber(decimal: maxAmountDecimal).int64Value

        if nextAmount > maxAmount {
            shouldShowWarning = true
            inputAmount = Decimal(maxAmount)
            inputString = "\(maxAmount)"
        } else {
            shouldShowWarning = false
            inputAmount = Decimal(nextAmount)
        }
        updateTotalQuantityIfNeeded()
    }

    private func tradeClicked(price: Int64) -> Bool {
        guard let livePrice = livePriceEntity?.price else { return false }
        let quantityToTrade = Decimal(price) / Decimal(livePrice)   // 매도 수량

        let entity = TradeEntity(
            name: name,
            buySell: type.rawValue,
            transactionQuantity: quantityToTrade,
            price: price,
            timestamp: Int64(Date().timeIntervalSince1970)
        )
        tradeUseCase.trade(with: entity)
        return true
    }
}
