//
//  TickerHeaderView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/7/25.
//

import UIKit
import SnapKit

final class TickerHeaderView: UITableViewHeaderFooterView, ReuseIdentifiable, ViewConfiguration {
    let coinLabel = UILabel()
    let priceButton = CoinFilterButton()
    let changedPriceButton = CoinFilterButton()
    let accButton = CoinFilterButton()

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
        [coinLabel, priceButton, changedPriceButton, accButton].forEach { contentView.addSubview($0) }
    }
    func configureLayout() {
        coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.25)
        }
        priceButton.snp.makeConstraints { make in
            make.trailing.equalTo(changedPriceButton.snp.leading).offset(-8)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.2)
        }
        changedPriceButton.snp.makeConstraints { make in
            make.trailing.equalTo(accButton.snp.leading).offset(-8)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.2)
        }
        accButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.25)
        }

    }
    func configureView() {
        contentView.backgroundColor = .customWhiteGray
        coinLabel.textAlignment = .left
        coinLabel.text = "코인"
        coinLabel.font = .boldSystemFont(ofSize: 14)
        priceButton.title.text = "현재가"
        changedPriceButton.title.text = "전일대비"
        accButton.title.text = "거래대금"
    }

}
