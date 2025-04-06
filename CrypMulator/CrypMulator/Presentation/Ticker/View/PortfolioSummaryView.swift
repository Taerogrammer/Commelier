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
        addSubviews([mainStack, bottomLine])
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
        backgroundColor = SystemColor.gray
        bottomLine.backgroundColor = SystemColor.green
    }

    func update(purchase: Double, eval: Double, profit: Double, yield: Double) {
        setFormattedValue(for: purchaseView, value: purchase)
        setFormattedValue(for: evalView, value: eval)
        setFormattedValue(for: profitView, value: profit, applyColor: true)
        setFormattedValue(for: yieldView, value: yield, isPercent: true, applyColor: true)
    }

    private func setFormattedValue(
        for view: PortfolioMetricView,
        value: Double,
        isPercent: Bool = false,
        applyColor: Bool = false
    ) {
        let formattedText: String
        if isPercent {
            formattedText = String(format: "%.2f%%", value)
        } else {
            formattedText = Int64(value).formattedWithComma
        }

        let color: UIColor = {
            guard applyColor else { return .label }
            return value > 0 ? SystemColor.red : (value < 0 ? SystemColor.green : .label)
        }()

        view.updateValue(formattedText, color: color)
    }

}
