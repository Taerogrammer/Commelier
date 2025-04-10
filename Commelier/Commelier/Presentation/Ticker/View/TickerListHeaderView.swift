//
//  TickerHeaderView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/7/25.
//

import UIKit
import NumberterKit
import SnapKit

final class TickerListHeaderView: BaseView, ReuseIdentifiable {
    private let portfolioSummaryView = PortfolioSummaryView()
    private let coinLabel = UILabel()
    let priceButton = CoinFilterButton()
    let changedPriceButton = CoinFilterButton()
    let accButton = CoinFilterButton()

    private let bottomLine = BaseView()

    override func configureHierarchy() {
        addSubviews([portfolioSummaryView, coinLabel, priceButton, changedPriceButton, accButton, bottomLine])
    }

    override func configureLayout() {
        portfolioSummaryView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(portfolioSummaryView.snp.bottom).offset(12)
            make.width.equalTo(snp.width).multipliedBy(0.2)
        }
        priceButton.snp.makeConstraints { make in
            make.trailing.equalTo(changedPriceButton.snp.leading).offset(-8)
            make.top.equalTo(portfolioSummaryView.snp.bottom).offset(12)
            make.width.equalTo(snp.width).multipliedBy(0.2)
            make.centerY.equalTo(coinLabel)
        }
        changedPriceButton.snp.makeConstraints { make in
            make.trailing.equalTo(accButton.snp.leading).offset(-8)
            make.top.equalTo(portfolioSummaryView.snp.bottom).offset(12)
            make.width.equalTo(snp.width).multipliedBy(0.2)
            make.centerY.equalTo(coinLabel)
        }
        accButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(portfolioSummaryView.snp.bottom).offset(12)
            make.width.equalTo(snp.width).multipliedBy(0.25)
            make.centerY.equalTo(coinLabel)
        }
        bottomLine.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    override func configureView() {
        backgroundColor = SystemColor.background

        coinLabel.text = StringLiteral.Ticker.coin
        coinLabel.textAlignment = .left
        coinLabel.font = SystemFont.Body.primary
        priceButton.title.text = StringLiteral.Ticker.currentPrice
        changedPriceButton.title.text = StringLiteral.Ticker.priceChanged
        accButton.title.text = StringLiteral.Ticker.tradeVolume
        bottomLine.backgroundColor = SystemColor.gray
    }
}

extension TickerListHeaderView {
    func updatePortfolioSummary(from snapshot: AssetSnapshotEntity) {
        portfolioSummaryView.update(
            purchase: snapshot.totalBuyValue.doubleValue,
            eval: snapshot.totalCoinValue.doubleValue,
            profit: snapshot.holdingProfit.doubleValue,
            yield: snapshot.holdingYieldRate.doubleValue
        )
    }
}
