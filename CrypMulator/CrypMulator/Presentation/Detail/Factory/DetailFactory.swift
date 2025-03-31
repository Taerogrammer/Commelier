//
//  DetailFactory.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Foundation

struct DetailFactory {
    static func make(with market: String) -> DetailViewController {
        let request = TickerDetailRequest(market: market)
        let webSocket: WebSocketProvider = WebSocketManager.shared

        let detailVM = DetailViewModel(request: request, webSocket: webSocket)
        let summaryVM = CoinLivePriceViewModel(request: request, webSocket: webSocket)
        let summaryView = CoinLivePriceView(viewModel: summaryVM)
        let coinMetricVM = CoinMetricViewModel(request: request, webSocket: webSocket)
        let coinMetricsView = CoinMetricsView(viewModel: coinMetricVM)

        // TODO: - File 생성 후 엔티티 바로 주입하기
        return DetailViewController(
            titleEntity: NavigationTitleEntity(imageURLString: nil, title: market),
            viewModel: detailVM,
            coinSummaryView: summaryView,
            coinMetricsView: coinMetricsView
        )
    }
}
