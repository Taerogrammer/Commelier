//
//  TotalAssetView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/27/25.
//

import UIKit
import SnapKit

final class TotalAssetView: BaseView {
    private let titleLabel = UILabel()

    private let totalAssetTitleLabel = UILabel()
    private let totalAssetAmountLabel = UILabel()
    private let chargeButton = UIButton()

    private let assetStackView = UIStackView()

    private let realAssetStackView = UIStackView()
    private let realCurrencyLabel = UILabel()
    private let realCurrencyAmountLabel = UILabel()

    private let coinAssetStackView = UIStackView()

    private let coinProfitStackView = UIStackView()
    private let coinCurrencyLabel = UILabel()
    private let coinCurrencyAmountLabel = UILabel()

    private let coinProfitRatioStackView = UIStackView()
    private let coinProfitLabel = UILabel()
    private let coinProfitAmountLabel = UILabel()
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
            coinProfitLabel, coinProfitAmountLabel
        ])

        coinProfitRatioStackView.addArrangedSubviews([
            coinProfitRatioLabel, coinProfitRatioAmountLabel
        ])

    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
        }
        totalAssetTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        totalAssetAmountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(totalAssetTitleLabel.snp.bottom).offset(4)
        }
        chargeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(totalAssetAmountLabel)
            make.height.equalTo(44)
            make.width.equalTo(96)
        }
        assetStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(chargeButton.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
    }

    override func configureView() {
        titleLabel.text = StringLiteral.Portfolio.assetOverview
        titleLabel.font = SystemFont.Title.large
        totalAssetTitleLabel.text = StringLiteral.Portfolio.totalAsset
        totalAssetTitleLabel.font = SystemFont.Title.small
        totalAssetAmountLabel.text = "38,185 원"
        totalAssetAmountLabel.font = SystemFont.Title.large
        chargeButton.setTitle(StringLiteral.Button.charge, for: .normal)
        chargeButton.titleLabel?.font = SystemFont.Button.secondary
        chargeButton.setTitleColor(SystemColor.black, for: .normal)
        chargeButton.clipsToBounds = true
        chargeButton.layer.cornerRadius = 8
        chargeButton.layer.borderWidth = 1

        // assetStackView
        assetStackView.axis = .horizontal
        assetStackView.distribution = .fillEqually
        assetStackView.alignment = .top

        // realAssetStackView (좌측 스택)
        realAssetStackView.axis = .vertical
        realAssetStackView.spacing = 12
        realAssetStackView.alignment = .fill

        realCurrencyLabel.font = SystemFont.Body.boldPrimary
        realCurrencyAmountLabel.font = SystemFont.Title.small
        realCurrencyLabel.text = "KRW"
        realCurrencyAmountLabel.text = "1,123,123 KRW"

        // coinAssetStackView (우측 스택)
        coinAssetStackView.axis = .vertical
        coinAssetStackView.spacing = 12
        coinAssetStackView.alignment = .fill

        coinCurrencyLabel.font = SystemFont.Body.boldPrimary
        coinCurrencyAmountLabel.font = SystemFont.Title.small
        coinCurrencyLabel.text = "가상 자산"
        coinCurrencyAmountLabel.text = "1,123,123,123 KRW"

        coinProfitLabel.font = SystemFont.Body.boldContent
        coinProfitLabel.textColor = SystemColor.gray
        coinProfitAmountLabel.font = SystemFont.Body.boldPrimary
        coinProfitAmountLabel.textAlignment = .right
        coinProfitRatioLabel.font = SystemFont.Body.boldContent
        coinProfitRatioLabel.textColor = SystemColor.gray
        coinProfitRatioAmountLabel.font = SystemFont.Body.boldPrimary
        coinProfitRatioAmountLabel.textAlignment = .right

        coinProfitLabel.text = "평가손익"
        coinProfitAmountLabel.text = "+4,234,234 KRW"
        coinProfitRatioLabel.text = "수익률"
        coinProfitRatioAmountLabel.text = "+ 55%"
    }

}
