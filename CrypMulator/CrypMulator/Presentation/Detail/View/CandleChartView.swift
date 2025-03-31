//
//  ChartContainerView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import UIKit
import SwiftUI
import SnapKit

final class CandleChartView: BaseView {
    var chartsHostingController: UIHostingController<ChartView>?

}

// MARK: - Chart
extension CandleChartView {
    func configureChartHostingView(with data: [ChartListEntity]) {
        let chartView = ChartView(data: data) // ✅ ChartEntity 사용
        let controller = UIHostingController(rootView: chartView)
        self.chartsHostingController = controller

        guard let chartUIView = controller.view else { return }
        addSubview(chartUIView)

        chartUIView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(360)
        }
    }
}
