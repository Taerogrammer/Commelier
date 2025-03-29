//
//  TotalAssetViewController.swift
//  CrypMulator
//
//  Created by 김태형 on 3/26/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class TotalAssetViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let currentAssetView = CurrentAssetView()
    private let portfolioChartView = PortfolioChartView()
    private let profitView = ProfitView()
    private let totalAssetViewModel = TotalAssetViewModel()

    override func configureHierarchy() {
        view.addSubviews([currentAssetView, portfolioChartView, profitView])
    }

    override func configureLayout() {
        currentAssetView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).dividedBy(2.6)
        }
        portfolioChartView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(currentAssetView.snp.bottom)
            make.height.equalTo(view.safeAreaLayoutGuide).dividedBy(2.6)
        }
        profitView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(portfolioChartView.snp.bottom)
        }
    }

    override func bind() {
        let input = TotalAssetViewModel.Input(
            chargeButtonTapped: currentAssetView.chargeButton.rx.tap)
        let output = totalAssetViewModel.transform(input: input)

        output.action
            .emit(with: self) { owner, action in
                switch action {
                case .presentCharge:
                    let vc = ChargeViewController()
                    if let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.prefersGrabberVisible = true
                        sheet.preferredCornerRadius = 20
                    }
                    vc.modalPresentationStyle = .formSheet
                    owner.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
