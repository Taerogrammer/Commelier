//
//  ProfitView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/27/25.
//

import UIKit
import SnapKit

final class ProfitView: BaseView {

    private let titleLabel = UILabel()

    private let contentStackView = UIStackView()

    private let leftStackView = UIStackView()
    private let profitTitleLabel = UILabel()
    private let profitRateTitleLabel = UILabel()

    private let rightStackView = UIStackView()
    private let profitAmountLabel = UILabel()
    private let profitRateLabel = UILabel()

    private let unitLabel = UILabel()
    private let percentLabel = UILabel()

    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(contentStackView)

        contentStackView.addArrangedSubviews([leftStackView, rightStackView])
        leftStackView.addArrangedSubviews([profitTitleLabel, profitRateTitleLabel])
        rightStackView.addArrangedSubviews([profitAmountLabel, profitRateLabel])
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }

        profitAmountLabel.setContentHuggingPriority(.required, for: .horizontal)
        profitRateLabel.setContentHuggingPriority(.required, for: .horizontal)
    }

    override func configureView() {
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fillEqually
        contentStackView.spacing = 16

        leftStackView.axis = .vertical
        leftStackView.spacing = 24
        leftStackView.alignment = .leading

        rightStackView.axis = .vertical
        rightStackView.spacing = 24
        rightStackView.alignment = .trailing

        titleLabel.text = StringLiteral.Portfolio.totalProfit
        titleLabel.font = SystemFont.Title.large

        profitTitleLabel.text = StringLiteral.Portfolio.cumulativeProfit
        profitTitleLabel.font = SystemFont.Body.boldPrimary

        profitRateTitleLabel.text = StringLiteral.Portfolio.cumulativeRate
        profitRateTitleLabel.font = SystemFont.Body.boldPrimary

        profitAmountLabel.font = SystemFont.Body.boldContent
        profitRateLabel.font = SystemFont.Body.boldContent

        profitAmountLabel.text = "+636,236,355 KRW"
        profitAmountLabel.textColor = .systemRed
        profitRateLabel.text = "46.62 %"
        profitRateLabel.textColor = .systemRed
    }
}
