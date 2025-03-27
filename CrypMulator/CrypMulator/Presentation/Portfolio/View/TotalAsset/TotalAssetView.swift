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
    private let coinCurrencyLabel = UILabel()
    private let coinCurrencyAmountLabel = UILabel()
    private let coinProfitLabel = UILabel()
    private let coinProfitAmountLabel = UILabel()
    private let coinProfitRatioLabel = UILabel()
    private let coinProfitRatioAmountLabel = UILabel()

    override func configureHierarchy() {
        addSubViews([titleLabel, totalAssetTitleLabel, totalAssetAmountLabel, chargeButton, assetStackView])
        assetStackView.addArrangedSubviews([
            realAssetStackView, coinAssetStackView
        ])
        realAssetStackView.addArrangedSubviews([
            realCurrencyLabel, realCurrencyAmountLabel
        ])
        coinAssetStackView.addArrangedSubviews([
            coinCurrencyLabel, coinCurrencyAmountLabel, coinCurrencyAmountLabel, coinProfitRatioLabel, coinProfitRatioAmountLabel
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
    }

}
