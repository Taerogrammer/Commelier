//
//  PortfolioSummaryViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 4/6/25.
//

import Combine
import Foundation

final class PortfolioSummaryViewModel: ViewModel {
    private let portfolioUseCase: PortfolioUseCaseProtocol
    private let webSocket: WebSocketProvider
    private var cancellables = Set<AnyCancellable>()
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

    struct Input {
    }

    struct Output {
        let snapshot: AnyPublisher<AssetSnapshotEntity, Never>
    }

    func transform(input: Input) -> Output {

        let snapshot = assetSnapshotPublisher
            .compactMap { $0 }
            .eraseToAnyPublisher()

        return Output(snapshot: snapshot)
    }

    func connectWebSocketAndSendMarkets() {
       let holdings = portfolioUseCase.getHoldings()
       /// 연결을 아무것도 전송하지 않으면 Snapshot이 전체가 오지 않아 데이터가 오지 않는 문제 발생
       let marketList = holdings.map { $0.name }.ifEmpty(default: ["KRW-BTC"])
       print("📡 WebSocket Send for Markets:", marketList)
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
//                    self.debug(snapshot: snapshot)
                }
            }
            .store(in: &cancellables)
    }

    private func debug(snapshot: AssetSnapshotEntity) {

        print("🧮 [EVALUATED] 총 자산: \(snapshot.totalAsset) 원")
        print("🧮 [EVALUATED] 총 현금: \(snapshot.totalCurrency) 원")
        print("SNAPSHOT =====", snapshot)
        print("🧮 [EVALUATED] 총 코인: \(snapshot.totalCoinValue.toInt64Rounded()) 원")
    }
}
