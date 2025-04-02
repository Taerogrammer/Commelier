//
//  TradeInfoView.swift
//  CrypMulator
//
//  Created by 김태형 on 4/2/25.
//

import UIKit
import SnapKit

final class TradeInfoView: BaseView {

    private let currentPriceTitleLabel = UILabel()
    let currentPriceLabel = UILabel()
    private let divider = UIView()

    let balanceInfoView: TradeAmountInfoView
    private let totalInfoView: TradeAmountInfoView

    private let infoStackView = UIStackView()

    init(type: OrderType) {
        self.balanceInfoView = TradeAmountInfoView(
            title: type.balanceTitle,
            amountText: StringLiteral.Trade.defaultString,
            unit: type.unit
        )

        self.totalInfoView = TradeAmountInfoView(
            title: StringLiteral.Trade.total,
            amountText: StringLiteral.Trade.defaultString,
            unit: type.coinUnit
        )

        super.init(frame: .zero)
    }

    override func configureHierarchy() {
        addSubviews([
            currentPriceTitleLabel,
            currentPriceLabel,
            divider,
            infoStackView
        ])
    }

    override func configureLayout() {
        currentPriceTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }

        currentPriceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }

        divider.snp.makeConstraints { make in
            make.top.equalTo(currentPriceLabel.snp.bottom).offset(24)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
        }

        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    override func configureView() {
        backgroundColor = SystemColor.whiteGray
        layer.cornerRadius = 12
        clipsToBounds = true

        currentPriceTitleLabel.text = StringLiteral.Trade.currentPrice
        currentPriceTitleLabel.font = SystemFont.Title.medium
        currentPriceTitleLabel.textColor = SystemColor.black

        currentPriceLabel.text = StringLiteral.Trade.loadingDots
        currentPriceLabel.font = SystemFont.Title.xLarge
        currentPriceLabel.textColor = SystemColor.black
        currentPriceLabel.textAlignment = .center

        divider.backgroundColor = SystemColor.gray

        infoStackView.axis = .vertical
        infoStackView.spacing = 8
        infoStackView.distribution = .fillEqually
        infoStackView.addArrangedSubview(balanceInfoView)
        infoStackView.addArrangedSubview(totalInfoView)
    }

    // 업데이트 메서드
    func updateCurrentPrice(with entity: LivePriceEntity) {
      currentPriceLabel.text = entity.price.description + StringLiteral.Currency.wonMark
    }

    func updateBalance(amount: String) {
        balanceInfoView.updateAmountText(amount)
    }

    func updateTotal(amount: String) {
        totalInfoView.updateAmountText(amount)
    }
}
