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

    private let topLineView = BaseView()
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
        contentView.addSubviews([topLineView, containerStackView, bottomLineView])
    }

    override func configureLayout() {
        topLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(topLineView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            make.bottom.equalTo(bottomLineView.snp.top)
        }

        bottomLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }

    override func configureView() {
        topLineView.backgroundColor = SystemColor.gray

        typeLabel.font = SystemFont.Title.small
        pairLabel.font = SystemFont.Body.small
        pairLabel.textColor = SystemColor.gray

        [priceTitleLabel, amountTitleLabel, totalTitleLabel, dateTitleLabel].forEach {
            $0.font = SystemFont.Body.content
            $0.textColor = SystemColor.black
        }

        [priceValueLabel, amountValueLabel, totalValueLabel, dateValueLabel].forEach {
            $0.font = SystemFont.Body.content
            $0.textAlignment = .right
        }

        dateValueLabel.textColor = SystemColor.gray

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
    func configure(with model: TradeHistoryModel) {
        typeLabel.text = model.type == .buy ? "매수" : "매도"
        typeLabel.textColor = model.type == .buy ? SystemColor.red : SystemColor.blue

        pairLabel.text = model.pair

        priceTitleLabel.text = "체결 가격"
        priceValueLabel.text = model.price

        amountTitleLabel.text = "체결 수량"
        amountValueLabel.text = model.amount
        amountValueLabel.textColor = model.type == .buy ? SystemColor.red : SystemColor.blue

        totalTitleLabel.text = "거래 금액"
        totalValueLabel.text = model.total

        dateTitleLabel.text = "체결 일시"
        dateValueLabel.text = model.date
    }

}

enum TradeType {
    case buy
    case sell
}

struct TradeHistoryModel {
    let type: TradeType
    let pair: String
    let price: String
    let amount: String
    let total: String
    let date: String
}
