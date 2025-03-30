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
    var chartsHostingController: UIHostingController<OldChartView>?

}

// MARK: - Chart
extension CandleChartView {
    func configureChartHostingView(with data: [ChartListEntity]) {
        let chartView = OldChartView(data: data) // ✅ ChartEntity 사용
        let controller = UIHostingController(rootView: chartView)
        self.chartsHostingController = controller

        guard let chartUIView = controller.view else { return }
        addSubview(chartUIView)

        chartUIView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
