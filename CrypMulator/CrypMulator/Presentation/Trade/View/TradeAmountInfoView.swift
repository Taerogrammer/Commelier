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
        leftTitleLabel.font = SystemFont.Body.boldPrimary

        amountLabel.text = amountText
        amountLabel.font = SystemFont.Title.small
        amountLabel.textAlignment = .right

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
            make.trailing.equalTo(unitLabel.snp.leading).offset(-6)
            make.centerY.equalToSuperview()
        }
    }
}

extension TradeAmountInfoView {
    func updateAmountText(_ text: String) {
        amountLabel.text = text
    }
}
