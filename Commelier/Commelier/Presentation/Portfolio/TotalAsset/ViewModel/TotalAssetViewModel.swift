//
//  TotalAssetViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import Combine
import NumberterKit
import Foundation
import RxSwift

final class TotalAssetViewModel: ViewModel {
    private let portfolioUseCase: PortfolioUseCaseProtocol
    private let webSocket: WebSocketProvider

    private var cancellables = Set<AnyCancellable>()
    private let actionPublisher = PassthroughSubject<Action, Never>()
    let assetSnapshotPublisher = CurrentValueSubject<AssetSnapshotEntity?, Never>(nil)
    private let disposeBag = DisposeBag()

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

    // TODO: - !긴급! 연동 여러 개 있을 때 다른 가격이 호출될 때도 있음
//     func connectWebSocketAndSendMarkets() {
//        let holdings = portfolioUseCase.getHoldings()
//        /// 연결을 아무것도 전송하지 않으면 Snapshot이 전체가 오지 않아 데이터가 오지 않는 문제 발생
//        let marketList = holdings.map { $0.name }.ifEmpty(default: ["KRW-BTC"])
//        print("📡 WebSocket Send for Markets:", marketList)
//        webSocket.send(markets: marketList)
//    }

    func connectWebSocketAndSendMarkets() {
        let holdings = portfolioUseCase.getHoldings()

        if holdings.isEmpty {
            NetworkManager.shared.getItem(
                api: UpbitRouter.getMarket(),
                type: [UpbitMarketResponse].self
            )
            .map { responses in
                responses
                    .compactMap { $0.toEntity() }
            }
            .subscribe(with: self) { owner, entities in
                let topMarkets = entities
                    .sorted(by: { $0.trade_price > $1.trade_price })
                    .prefix(10)
                    .map { $0.market }

                print("📡 Default WebSocket Market Top10:", topMarkets)
                owner.webSocket.send(markets: topMarkets)
            } onFailure: { owner, error in
                print("❌ Failed to fetch default market list", error)
            }
            .disposed(by: disposeBag)

        } else {
            let marketList = holdings.map { $0.name }
            print("📡 WebSocket Send for Holdings:", marketList)
            webSocket.send(markets: marketList)
        }
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
        print("🧮 [EVALUATED] 총 코인: \(snapshot.totalCoinValue.toRoundedInt64()) 원")
    }

}

extension Array {
    func ifEmpty(default defaultValue: [Element]) -> [Element] {
        return self.isEmpty ? defaultValue : self
    }
}
