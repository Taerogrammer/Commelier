//
//  TickerHeaderView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/7/25.
//

import UIKit
import SnapKit

final class TickerListHeaderView: UITableViewHeaderFooterView, ReuseIdentifiable, ViewConfiguration {
    private let portfolioSummaryView = PortfolioSummaryView()
    private let coinLabel = UILabel()
    let priceButton = CoinFilterButton()
    let changedPriceButton = CoinFilterButton()
    let accButton = CoinFilterButton()

    private let bottomLine = BaseView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubViews([portfolioSummaryView, coinLabel, priceButton, changedPriceButton, accButton, bottomLine])
    }

    func configureLayout() {
        portfolioSummaryView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(portfolioSummaryView.snp.bottom).offset(12)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.2)
        }
        priceButton.snp.makeConstraints { make in
            make.trailing.equalTo(changedPriceButton.snp.leading).offset(-8)
            make.top.equalTo(portfolioSummaryView.snp.bottom).offset(12)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.2)
            make.centerY.equalTo(coinLabel)
        }
        changedPriceButton.snp.makeConstraints { make in
            make.trailing.equalTo(accButton.snp.leading).offset(-8)
            make.top.equalTo(portfolioSummaryView.snp.bottom).offset(12)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.2)
            make.centerY.equalTo(coinLabel)
        }
        accButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(portfolioSummaryView.snp.bottom).offset(12)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.25)
            make.centerY.equalTo(coinLabel)
        }
        bottomLine.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    func configureView() {
        coinLabel.textAlignment = .left
        coinLabel.text = StringLiteral.Ticker.coin
        coinLabel.font = .boldSystemFont(ofSize: 14)
        priceButton.title.text = StringLiteral.Ticker.currentPrice
        changedPriceButton.title.text = StringLiteral.Ticker.priceChanged
        accButton.title.text = StringLiteral.Ticker.tradeVolume
        bottomLine.backgroundColor = .customGray
    }
}
