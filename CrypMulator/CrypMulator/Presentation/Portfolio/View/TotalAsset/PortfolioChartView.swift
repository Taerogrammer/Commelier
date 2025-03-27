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
        addSubviews([titleLabel, pieChartView, legendStackView])
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
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
        pieChartView.centerText = "보유비중\n(%)"

        legendStackView.axis = .vertical
        legendStackView.spacing = 12
        legendStackView.alignment = .center

        // ✅ 내부 테스트용 샘플 데이터 호출
        let sampleData: [(String, Double, UIColor)] = [
            ("KRW", 99.7, .systemGreen),
            ("DOGE", 0.3, SystemColor.blue)
        ]
        configureChart(data: sampleData)
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

        let chartData = PieChartData(dataSet: dataSet)
        pieChartView.data = chartData

        // 레전드 구성
        legendStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for item in data {
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
        percentLabel.text = String(format: "%.1f%%", percent)
        percentLabel.font = SystemFont.Body.content

        let hStack = UIStackView(arrangedSubviews: [colorDot, nameLabel, percentLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8
        return hStack
    }
}
