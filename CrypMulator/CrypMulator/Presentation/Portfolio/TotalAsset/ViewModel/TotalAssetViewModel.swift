//
//  TotalAssetViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import Combine
import Foundation

final class TotalAssetViewModel: ViewModel {
    private let portfolioUseCase: PortfolioUseCaseProtocol
    private let webSocket: WebSocketProvider

    private var cancellables = Set<AnyCancellable>()
    private let actionPublisher = PassthroughSubject<Action, Never>()
    let assetSnapshotPublisher = CurrentValueSubject<AssetSnapshotEntity?, Never>(nil)

    init(portfolioUseCase: PortfolioUseCaseProtocol,
         webSocket: WebSocketProvider) {
        self.portfolioUseCase = portfolioUseCase
        self.webSocket = webSocket

        let holdings = portfolioUseCase.getHoldings()
        let marketList = holdings.map { $0.name }

        print("📡 WebSocket Send for Markets:", marketList)

        connectWebSocketAndSendMarkets()
        observeLivePriceAndEvaluate()
    }

    enum Action {
        case presentCharge
    }

    struct Input {
        let chargeButtonTapped: AnyPublisher<Void, Never>
    }

    struct Output {
        let action: AnyPublisher<Action, Never>
        let snapshot: AnyPublisher<AssetSnapshotEntity, Never>
    }

    func transform(input: Input) -> Output {
        input.chargeButtonTapped
            .sink { [weak self] in
                self?.actionPublisher.send(.presentCharge)
            }
            .store(in: &cancellables)

        let snapshot = assetSnapshotPublisher
            .compactMap { $0 }
            .eraseToAnyPublisher()

        return Output(action: actionPublisher.eraseToAnyPublisher(),
                      snapshot: snapshot)
    }

    private func connectWebSocketAndSendMarkets() {
        let holdings = portfolioUseCase.getHoldings()
        let marketList = holdings.map { $0.name }
        print("📡 WebSocket Send for Markets:", marketList)
        webSocket.connect()
        guard !marketList.isEmpty else {
            print("⚠️ 마켓이 비어 있어 send 생략")
            return
        }
        webSocket.send(markets: marketList)
    }

    private func observeLivePriceAndEvaluate() {
        webSocket.livePricePublisher
            .map { [$0.market: Decimal($0.price)] } // ✅ Decimal로 변환
            .scan([String: Decimal]()) { currentPrices, newEntry in
                var updated = currentPrices
                for (market, price) in newEntry {
                    updated[market] = price
                }
                return updated
            }
            .sink { [weak self] currentPrices in
                guard let self else { return }

                DispatchQueue.main.async {
                    let asset = self.portfolioUseCase.getCurrentAssetEntity()
                    let snapshot = AssetEvaluator.evaluate(from: asset, currentPrices: currentPrices)
                    self.assetSnapshotPublisher.send(snapshot)
                }
            }
            .store(in: &cancellables)
    }


    // MARK: - snapshot debug
    private func debug(snapshot: AssetSnapshotEntity) {

        print("🧮 [EVALUATED] 총 자산: \(snapshot.totalAsset) 원")
        print("🧮 [EVALUATED] 총 현금: \(snapshot.totalCurrency) 원")
        print("SNAPSHOT =====", snapshot)
        print("🧮 [EVALUATED] 총 코인: \(snapshot.totalCoinValue.toInt64Rounded()) 원")
    }

}
