//
//  TradeAmountInfoView.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import UIKit
import SnapKit

final class TradeAmountInfoView: BaseView {

    private let leftTitleLabel = UILabel()
    let amountLabel = UILabel()
    private let unitLabel = UILabel()

    init(title: String, amountText: String, unit: String) {
        super.init(frame: .zero)
        configure(title: title, amountText: amountText, unit: unit)
    }

    private func configure(title: String, amountText: String, unit: String) {
        leftTitleLabel.text = title
        leftTitleLabel.textColor = SystemColor.label
        leftTitleLabel.font = SystemFont.Body.boldPrimary

        amountLabel.text = amountText
        amountLabel.textColor = SystemColor.label
        amountLabel.font = SystemFont.Title.small
        amountLabel.textAlignment = .right

        /*
         // 크기에 맞게 모든 값 들어오게
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.minimumScaleFactor = 0.8
        amountLabel.lineBreakMode = .byTruncatingTail
        amountLabel.numberOfLines = 1
         */

        unitLabel.text = unit
        unitLabel.font = SystemFont.Title.small
        unitLabel.textAlignment = .right
    }

    override func configureHierarchy() {
        addSubviews([leftTitleLabel, amountLabel, unitLabel])
    }

    override func configureLayout() {
        leftTitleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        unitLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        amountLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftTitleLabel.snp.trailing).offset(8)
            make.trailing.equalTo(unitLabel.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }

        // Hugging / Compression 설정
        leftTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        unitLabel.setContentHuggingPriority(.required, for: .horizontal)

        amountLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        amountLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

extension TradeAmountInfoView {
    func updateAmountText(_ text: String) {
        amountLabel.text = text
    }
}
