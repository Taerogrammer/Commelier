//
//  PortfolioSummaryView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/25/25.
//

import UIKit
import SnapKit

final class PortfolioSummaryView: BaseView {
    private let purchaseView = PortfolioMetricView(title: StringLiteral.Portfolio.totalBuyPrice)
    private let evalView = PortfolioMetricView(title: StringLiteral.Portfolio.totalEvaluation)
    private let profitView = PortfolioMetricView(title: StringLiteral.Portfolio.profitLoss)
    private let yieldView = PortfolioMetricView(title: StringLiteral.Portfolio.yieldRate, initialValue: "0.00%")

    private lazy var leftStack = UIStackView(arrangedSubviews: [purchaseView, evalView])
    private lazy var rightStack = UIStackView(arrangedSubviews: [profitView, yieldView])
    private lazy var mainStack = UIStackView(arrangedSubviews: [leftStack, rightStack])

    private let bottomLine = BaseView()

    override func configureHierarchy() {
        addSubViews([mainStack, bottomLine])
    }

    override func configureLayout() {
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    }

    override func configureView() {
        backgroundColor = SystemColor.whiteGray
        bottomLine.backgroundColor = SystemColor.blue
    }

    func update(purchase: Double, eval: Double, profit: Double, yield: Double) {
        purchaseView.updateValue(purchase)
        evalView.updateValue(eval)
        profitView.updateValue(profit)
        yieldView.updateValueFormatted(yield)
    }
}
