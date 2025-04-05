//
//  PortfolioChartView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/27/25.
//

import UIKit
import DGCharts
import SnapKit

final class PortfolioChartView: BaseView {

    private let titleLabel = UILabel()
    private let pieChartView = PieChartView()
    private let legendStackView = UIStackView()

    override func configureHierarchy() {
        addSubviews([
            titleLabel,
            pieChartView,
            legendStackView
        ])
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }

        pieChartView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(180)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }

        legendStackView.snp.makeConstraints { make in
            make.leading.equalTo(pieChartView.snp.trailing).offset(24)
            make.centerY.equalTo(pieChartView)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }

    override func configureView() {
        titleLabel.text = StringLiteral.Portfolio.portfolioRatio
        titleLabel.font = SystemFont.Title.large

        pieChartView.highlightPerTapEnabled = false
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawHoleEnabled = true
        pieChartView.holeRadiusPercent = 0.5
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.legend.enabled = false
        pieChartView.centerText = StringLiteral.Portfolio.chartText

        legendStackView.axis = .vertical
        legendStackView.spacing = 12
        legendStackView.alignment = .center
    }
}

// MARK: - Chart
extension PortfolioChartView {

    private func configureChart(data: [(name: String, value: Double, color: UIColor)]) {
        let entries = data.map {
            PieChartDataEntry(value: $0.value, label: $0.name)
        }

        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = data.map { $0.color }
        dataSet.drawValuesEnabled = false
        dataSet.selectionShift = 0

        let chartData = PieChartData(dataSet: dataSet)
        pieChartView.data = chartData

        legendStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        data.forEach { item in
            let legendItem = makeLegendItem(color: item.color, name: item.name, percent: item.value)
            legendStackView.addArrangedSubview(legendItem)
        }
    }

    private func makeLegendItem(color: UIColor, name: String, percent: Double) -> UIView {
        let colorDot = UIView()
        colorDot.backgroundColor = color
        colorDot.layer.cornerRadius = 5
        colorDot.snp.makeConstraints { $0.size.equalTo(10) }

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = SystemFont.Body.content

        let percentLabel = UILabel()
        percentLabel.text = String(format: "%.2f%%", percent)
        percentLabel.font = SystemFont.Body.content

        let hStack = UIStackView(arrangedSubviews: [colorDot, nameLabel, percentLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        return hStack
    }
}

// MARK: - configure
extension PortfolioChartView {
    func update(snapshot: AssetSnapshotEntity) {
        let total = snapshot.totalAsset

        guard total > 0 else {
            // 데이터가 유효하지 않을 경우 차트 클리어
            configureChart(data: [])
            return
        }

        let cashPercent = (snapshot.totalCurrency / total * 100).doubleValue
        let coinPercent = (snapshot.totalCoinValue / total * 100).doubleValue

        // TODO: - 각 코인에 대해 나타내주기
        let chartData: [(String, Double, UIColor)] = [
            (StringLiteral.Portfolio.currency, cashPercent, SystemColor.blue),
            (StringLiteral.Portfolio.coin, coinPercent, SystemColor.yellow)
        ]

        configureChart(data: chartData)
    }
}
