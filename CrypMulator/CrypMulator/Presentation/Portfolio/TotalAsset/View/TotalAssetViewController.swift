//
//  TotalAssetViewController.swift
//  CrypMulator
//
//  Created by 김태형 on 3/26/25.
//

import Combine
import UIKit
import SnapKit

final class TotalAssetViewController: BaseViewController {
    private var cancellables = Set<AnyCancellable>()
    private let currentAssetView = CurrentAssetView()
    private let portfolioChartView = PortfolioChartView()
    private let profitView = ProfitView()
    private let totalAssetViewModel: TotalAssetViewModel
    private let chargeRepository: ChargeRepositoryProtocol

    init(viewModel: TotalAssetViewModel, chargeRepository: ChargeRepositoryProtocol) {
        self.totalAssetViewModel = viewModel
        self.chargeRepository = chargeRepository
        super.init()
    }

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
            chargeButtonTapped: currentAssetView.chargeButton
                .publisherForEvent(.touchUpInside)
                .eraseToAnyPublisher()
        )

        let output = totalAssetViewModel.transform(input: input)

        output.action
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .presentCharge:
                    let vc = ChargeFactory.make(repository: self.chargeRepository)
                    if let sheet = vc.sheetPresentationController {
                        sheet.detents = [.medium()]
                        sheet.prefersGrabberVisible = true
                        sheet.preferredCornerRadius = 20
                    }
                    vc.modalPresentationStyle = .formSheet
                    self.present(vc, animated: true)
                }
            }
            .store(in: &cancellables)

        output.snapshot
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                self?.currentAssetView.update(snapshot: snapshot)
                self?.portfolioChartView.update(snapshot: snapshot)
            }
            .store(in: &cancellables)
    }
}
