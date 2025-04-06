//
//  TotalAssetView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/27/25.
//

import UIKit
import SnapKit

final class CurrentAssetView: BaseView {

    /// Title Section
    private let titleLabel = UILabel()
    private let totalAssetTitleLabel = UILabel()
    private let totalAssetAmountLabel = UILabel()
    let chargeButton = ActionButton(
        title: StringLiteral.Button.charge,
        titleColor: SystemColor.white,
        backgroundColor: SystemColor.green,
        font: SystemFont.Button.secondary
    )

    /// Asset Stack
    private let assetStackView = UIStackView()

    /// Real Asset Section (Left)
    private let realAssetStackView = UIStackView()
    private let realCurrencyLabel = UILabel()
    private let realCurrencyAmountLabel = UILabel()

    /// Coin Asset Section (Right)
    private let coinAssetStackView = UIStackView()
    private let coinCurrencyLabel = UILabel()
    private let coinCurrencyAmountLabel = UILabel()

    private let coinProfitStackView = UIStackView()
    private let coinProfitLabel = UILabel()
    private let coinProfitAmountLabel = UILabel()

    private let coinProfitRatioStackView = UIStackView()
    private let coinProfitRatioLabel = UILabel()
    private let coinProfitRatioAmountLabel = UILabel()

    override func configureHierarchy() {
        addSubviews([
            titleLabel,
            totalAssetTitleLabel,
            totalAssetAmountLabel,
            chargeButton,
            assetStackView
        ])

        assetStackView.addArrangedSubviews([
            realAssetStackView,
            coinAssetStackView
        ])

        realAssetStackView.addArrangedSubviews([
            realCurrencyLabel,
            realCurrencyAmountLabel
        ])

        coinAssetStackView.addArrangedSubviews([
            coinCurrencyLabel,
            coinCurrencyAmountLabel,
            coinProfitStackView,
            coinProfitRatioStackView
        ])

        coinProfitStackView.addArrangedSubviews([
            coinProfitLabel,
            coinProfitAmountLabel
        ])

        coinProfitRatioStackView.addArrangedSubviews([
            coinProfitRatioLabel,
            coinProfitRatioAmountLabel
        ])
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }

        totalAssetTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
        }

        totalAssetAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(totalAssetTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(16)
        }

        chargeButton.snp.makeConstraints { make in
            make.centerY.equalTo(totalAssetAmountLabel)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(48)
        }

        assetStackView.snp.makeConstraints { make in
            make.top.equalTo(chargeButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    override func configureView() {
        /// Title
        titleLabel.text = StringLiteral.Portfolio.assetOverview
        titleLabel.textColor = SystemColor.white
        titleLabel.font = SystemFont.Title.large

        totalAssetTitleLabel.text = StringLiteral.Portfolio.totalAsset
        totalAssetTitleLabel.textColor = SystemColor.white
        totalAssetTitleLabel.font = SystemFont.Title.small

        totalAssetAmountLabel.text = "0 " + StringLiteral.Currency.won
        totalAssetAmountLabel.font = SystemFont.Title.large

        /// StackView configs
        assetStackView.axis = .horizontal
        assetStackView.distribution = .fillEqually
        assetStackView.alignment = .top

        realAssetStackView.axis = .vertical
        realAssetStackView.spacing = 12
        realAssetStackView.alignment = .fill

        coinAssetStackView.axis = .vertical
        coinAssetStackView.spacing = 12
        coinAssetStackView.alignment = .fill

        coinProfitStackView.axis = .horizontal
        coinProfitStackView.spacing = 8
        coinProfitStackView.alignment = .center

        coinProfitRatioStackView.axis = .horizontal
        coinProfitRatioStackView.spacing = 8
        coinProfitRatioStackView.alignment = .center

        /// Real asset
        realCurrencyLabel.text = StringLiteral.Currency.krw
        realCurrencyLabel.textColor = SystemColor.white
        realCurrencyLabel.font = SystemFont.Body.boldPrimary

        realCurrencyAmountLabel.text = "0 " + StringLiteral.Currency.krw
        realCurrencyAmountLabel.textColor = SystemColor.white
        realCurrencyAmountLabel.font = SystemFont.Title.small

        /// Coin asset
        coinCurrencyLabel.text = StringLiteral.Portfolio.coinAsset
        coinCurrencyLabel.textColor = SystemColor.white
        coinCurrencyLabel.font = SystemFont.Body.boldPrimary

        coinCurrencyAmountLabel.text = "0 " + StringLiteral.Currency.krw
        coinCurrencyAmountLabel.textColor = SystemColor.white
        coinCurrencyAmountLabel.font = SystemFont.Title.small

        coinProfitLabel.text = StringLiteral.Portfolio.profitLoss
        coinProfitLabel.textColor = SystemColor.white
        coinProfitLabel.font = SystemFont.Body.boldContent

        coinProfitAmountLabel.text = "0 " + StringLiteral.Currency.krw
        coinProfitAmountLabel.font = SystemFont.Body.boldPrimary
        coinProfitAmountLabel.textColor = SystemColor.white
        coinProfitAmountLabel.textAlignment = .right

        coinProfitRatioLabel.text = StringLiteral.Portfolio.yieldRate
        coinProfitRatioLabel.textColor = SystemColor.white
        coinProfitRatioLabel.font = SystemFont.Body.boldContent

        coinProfitRatioAmountLabel.text = "0 %"
        coinProfitRatioAmountLabel.font = SystemFont.Body.boldPrimary
        coinProfitRatioAmountLabel.textColor = SystemColor.white
        coinProfitRatioAmountLabel.textAlignment = .right
    }
}

// MARK: - configure
extension CurrentAssetView {
    func update(snapshot: AssetSnapshotEntity) {
        totalAssetAmountLabel.text = snapshot.totalAsset.toInt64Rounded().formattedWithComma + " " + StringLiteral.Currency.won

        realCurrencyAmountLabel.text = snapshot.totalCurrency.toInt64Rounded().formattedWithComma + " " + StringLiteral.Currency.won

        coinCurrencyAmountLabel.text = snapshot.totalCoinValue.toInt64Rounded().formattedWithComma + " " + StringLiteral.Currency.won

        let profit = snapshot.holdingProfit
        let profitText = profit.toInt64Rounded().formattedWithComma + " " + StringLiteral.Currency.won
        coinProfitAmountLabel.text = profitText
        coinProfitAmountLabel.textColor = profit > 0 ? SystemColor.red : (profit < 0 ? SystemColor.green : SystemColor.white)

        let yield = snapshot.holdingYieldRate
        let yieldText = yield.formatted() + StringLiteral.Operator.percentage
        coinProfitRatioAmountLabel.text = yieldText
        coinProfitRatioAmountLabel.textColor = yield > 0 ? SystemColor.red : (yield < 0 ? SystemColor.green : SystemColor.white)
    }
}
