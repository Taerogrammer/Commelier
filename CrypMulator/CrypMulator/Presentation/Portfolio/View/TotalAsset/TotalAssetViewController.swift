//
//  TotalAssetViewController.swift
//  CrypMulator
//
//  Created by 김태형 on 3/26/25.
//

import UIKit
import SnapKit

final class TotalAssetViewController: BaseViewController {
    private let totalAssetView = TotalAssetView()
    private let portfolioChartView = PortfolioChartView()
    private let profitView = ProfitView()

    override func configureHierarchy() {
        view.addSubviews([totalAssetView, portfolioChartView, profitView])
    }

    override func configureLayout() {
        totalAssetView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).dividedBy(2.6)
        }
        portfolioChartView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(totalAssetView.snp.bottom)
            make.height.equalTo(view.safeAreaLayoutGuide).dividedBy(2.6)
        }
        profitView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(portfolioChartView.snp.bottom)
        }
    }

    override func configureView() {

    }
}
