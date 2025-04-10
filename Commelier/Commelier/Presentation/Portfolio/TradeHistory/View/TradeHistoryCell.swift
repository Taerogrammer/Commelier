//
//  TradeHistoryCell.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import UIKit
import SnapKit

final class TradeHistoryCell: BaseTableViewCell, ReuseIdentifiable {

    private let typeLabel = UILabel()
    private let pairLabel = UILabel()

    private let leftStackView = UIStackView()
    private let infoStackView = UIStackView()
    private let containerStackView = UIStackView()

    private let priceTitleLabel = UILabel()
    private let priceValueLabel = UILabel()

    private let amountTitleLabel = UILabel()
    private let amountValueLabel = UILabel()

    private let totalTitleLabel = UILabel()
    private let totalValueLabel = UILabel()

    private let dateTitleLabel = UILabel()
    private let dateValueLabel = UILabel()

    private let bottomLineView = BaseView()

    override func configureHierarchy() {
        leftStackView.addArrangedSubviews([typeLabel, pairLabel])

        infoStackView.addArrangedSubviews([
            StackFactory.horizontalRowStack(left: priceTitleLabel, right: priceValueLabel),
            StackFactory.horizontalRowStack(left: amountTitleLabel, right: amountValueLabel),
            StackFactory.horizontalRowStack(left: totalTitleLabel, right: totalValueLabel),
            StackFactory.horizontalRowStack(left: dateTitleLabel, right: dateValueLabel)
        ])

        containerStackView.addArrangedSubviews([leftStackView, infoStackView])
        contentView.addSubviews([/*topLineView,*/ containerStackView, bottomLineView])
    }

    override func configureLayout() {
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            make.bottom.equalTo(bottomLineView.snp.top)
        }

        leftStackView.snp.makeConstraints { make in
            make.width.equalTo(120) // 원하는 고정값 (조절 가능)
        }

        bottomLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = SystemColor.background

        typeLabel.font = SystemFont.Title.small
        pairLabel.font = SystemFont.Body.small
        pairLabel.textColor = SystemColor.secondaryText

        [priceTitleLabel, amountTitleLabel, totalTitleLabel, dateTitleLabel].forEach {
            $0.font = SystemFont.Body.content
            $0.textColor = SystemColor.label
        }

        [priceValueLabel, amountValueLabel, totalValueLabel, dateValueLabel].forEach {
            $0.font = SystemFont.Body.content
            $0.textAlignment = .right
        }

        dateValueLabel.textColor = SystemColor.secondaryText

        leftStackView.axis = .vertical
        leftStackView.spacing = 4
        leftStackView.alignment = .leading

        infoStackView.axis = .vertical
        infoStackView.spacing = 6
        infoStackView.alignment = .fill

        containerStackView.axis = .horizontal
        containerStackView.spacing = 16
        containerStackView.alignment = .center

        bottomLineView.backgroundColor = SystemColor.gray
    }
}

// MARK: - configure
extension TradeHistoryCell {
    func configure(with model: TradeHistoryEntity) {
        typeLabel.text = model.type.text
        typeLabel.textColor = model.type.color

        pairLabel.text = model.market

        priceTitleLabel.text = StringLiteral.TradeHistory.price
        priceValueLabel.text = model.price

        amountTitleLabel.text = StringLiteral.TradeHistory.quantity
        amountValueLabel.text = model.amount
        amountValueLabel.textColor = model.type.color

        totalTitleLabel.text = StringLiteral.TradeHistory.coinPrice
        totalValueLabel.text = model.total

        dateTitleLabel.text = StringLiteral.TradeHistory.date
        dateValueLabel.text = model.date
    }
}
