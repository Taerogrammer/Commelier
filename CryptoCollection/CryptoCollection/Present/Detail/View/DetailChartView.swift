//
//  DetailChartView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import SwiftUI
import SnapKit

final class DetailChartView: BaseView {
    let moneyLabel = UILabel()
    let rateLabel = UILabel()
    let updateDateLabel = UILabel()
    var chartsHostingController: UIHostingController<ChartView>?

    override func configureHierarchy() {
        [moneyLabel, rateLabel, updateDateLabel].forEach { addSubview($0) }
    }

    override func configureLayout() {
        moneyLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(12)
            make.top.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(32)
        }
        rateLabel.snp.makeConstraints { make in
            make.leading.equalTo(moneyLabel)
            make.top.equalTo(moneyLabel.snp.bottom).offset(4)
            make.height.equalTo(14)
        }
        updateDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(moneyLabel)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(12)
        }
    }

    override func configureView() {
        configureChartHostingView()
        moneyLabel.font = .boldSystemFont(ofSize: 26)
        rateLabel.font = .boldSystemFont(ofSize: 12)
        updateDateLabel.font = .systemFont(ofSize: 8)

        moneyLabel.textColor = UIColor.customBlack
        updateDateLabel.textColor = UIColor.customGray

        moneyLabel.text = "$140,123,123"
        rateLabel.text = "^0.98%"
        updateDateLabel.text = "2/15 18:00:45 업데이트"
    }

}

// MARK: - Chart
extension DetailChartView {
    private func configureChartHostingView() {
//        let chartView = ChartView()
        let chartView = ChartView()
        let controller = UIHostingController(rootView: chartView)
        self.chartsHostingController = controller

        guard let chartUIView = controller.view else { return }
        addSubview(chartUIView)

        chartUIView.snp.makeConstraints { make in
            make.top.equalTo(rateLabel.snp.bottom).inset(-12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(12)
            make.bottom.equalTo(updateDateLabel.snp.top).inset(-8)
        }
    }
}
