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
        let detailVM = DetailViewModel(request: request)
        let summaryVM = CoinSummaryViewModel(request: request)
        let summaryView = CoinLivePriceView(viewModel: summaryVM)

        return DetailViewController(
            viewModel: detailVM,
            coinSummaryView: summaryView
        )
    }
}
