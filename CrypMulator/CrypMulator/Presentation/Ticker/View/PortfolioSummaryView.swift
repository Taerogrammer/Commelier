//
//  PortfolioSummaryView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/25/25.
//

import UIKit
import SnapKit

final class PortfolioSummaryView: BaseView {
    private let purchaseView = PortfolioMetricView(title: "총 매수")
    private let evalView = PortfolioMetricView(title: "총 평가")
    private let profitView = PortfolioMetricView(title: "평가손익")
    private let yieldView = PortfolioMetricView(title: "수익률", initialValue: "0.00%")

    private lazy var leftStack = UIStackView(arrangedSubviews: [purchaseView, evalView])
    private lazy var rightStack = UIStackView(arrangedSubviews: [profitView, yieldView])
    private lazy var mainStack = UIStackView(arrangedSubviews: [leftStack, rightStack])

    private let bottomLine = BaseView()

    override func configureHierarchy() {
        addSubViews([mainStack, bottomLine])
    }

    override func configureLayout() {
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        bottomLine.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }

        [leftStack, rightStack].forEach {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 4
        }

        mainStack.axis = .horizontal
        mainStack.distribution = .fillEqually
        mainStack.spacing = 8
    }

    override func configureView() {
        backgroundColor = .customWhiteGray
        bottomLine.backgroundColor = .customBlue
    }

    func update(purchase: Double, eval: Double, profit: Double, yield: Double) {
        purchaseView.updateValue(purchase)
        evalView.updateValue(eval)
        profitView.updateValue(profit)
        yieldView.updateValueFormatted(yield)
    }
}
