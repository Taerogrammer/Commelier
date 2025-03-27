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
        backgroundColor = .white

        titleLabel.text = "투자손익"
        titleLabel.font = SystemFont.Title.large

        contentStackView.axis = .horizontal
        contentStackView.distribution = .fillEqually
        contentStackView.spacing = 16

        leftStackView.axis = .vertical
        leftStackView.spacing = 24
        leftStackView.alignment = .leading

        rightStackView.axis = .vertical
        rightStackView.spacing = 24
        rightStackView.alignment = .trailing

        profitTitleLabel.text = "누적 손익"
        profitTitleLabel.font = SystemFont.Body.boldPrimary

        profitRateTitleLabel.text = "누적 손익률"
        profitRateTitleLabel.font = SystemFont.Body.boldPrimary

        profitAmountLabel.text = "+636,236,355 KRW"
        profitAmountLabel.textColor = .systemRed
        profitAmountLabel.font = SystemFont.Body.boldContent

        profitRateLabel.text = "46.62 %"
        profitRateLabel.textColor = .systemRed
        profitRateLabel.font = SystemFont.Body.boldContent
    }
}
