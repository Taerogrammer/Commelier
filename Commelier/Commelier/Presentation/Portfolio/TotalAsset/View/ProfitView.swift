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

    override func configureHierarchy() {
        addSubviews([titleLabel, contentStackView])

        contentStackView.addArrangedSubviews([leftStackView, rightStackView])

        leftStackView.addArrangedSubviews([
            profitTitleLabel,
            profitRateTitleLabel
        ])

        rightStackView.addArrangedSubviews([
            profitAmountLabel,
            profitRateLabel
        ])
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
        backgroundColor = SystemColor.background

        titleLabel.text = StringLiteral.Portfolio.totalProfit
        titleLabel.textColor = SystemColor.label
        titleLabel.font = SystemFont.Title.large

        // StackView configs
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fillEqually
        contentStackView.spacing = 16

        leftStackView.axis = .vertical
        leftStackView.spacing = 24
        leftStackView.alignment = .leading

        rightStackView.axis = .vertical
        rightStackView.spacing = 24
        rightStackView.alignment = .trailing

        // Labels
        profitTitleLabel.text = StringLiteral.Portfolio.cumulativeProfit
        profitTitleLabel.textColor = SystemColor.label
        profitTitleLabel.font = SystemFont.Body.boldPrimary

        profitRateTitleLabel.text = StringLiteral.Portfolio.cumulativeRate
        profitRateTitleLabel.textColor = SystemColor.label
        profitRateTitleLabel.font = SystemFont.Body.boldPrimary

        profitAmountLabel.text = "0 " + StringLiteral.Currency.krw
        profitAmountLabel.font = SystemFont.Body.boldContent
        profitAmountLabel.textColor = SystemColor.label

        profitRateLabel.text = "0 " + StringLiteral.Operator.percentage
        profitRateLabel.font = SystemFont.Body.boldContent
        profitRateLabel.textColor = SystemColor.label
    }
}

extension ProfitView {
    func update(amount: String, rate: String) {
        profitAmountLabel.text = amount
        profitRateLabel.text = rate

        let isProfit = amount.contains(StringLiteral.Operator.plus)
        let color: UIColor = isProfit ? SystemColor.red : SystemColor.green

        profitAmountLabel.textColor = color
        profitRateLabel.textColor = color
    }
}
