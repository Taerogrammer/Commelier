//
//  DetailViewController.swift
//  CrypMulator
//
//  Created by 김태형 on 3/29/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class DetailViewController: BaseViewController {
    private let viewModel: DetailViewModel
    private var disposeBag = DisposeBag()

    private let barButton = UIBarButtonItem(
        image: SystemIcon.arrowLeft,
        style: .plain,
        target: nil,
        action: nil)
    private let favoriteButton = UIBarButtonItem()

    private let scrollView = UIScrollView()
    private let containerView = BaseView()

    private let coinLivePriceView: CoinLivePriceView

    private let segmentedControl = CustomSegmentedControl()
    private let segmentedContainerView = BaseView()

    private var views: [BaseView] = []
    private let candleChartView = CandleChartView()
    private let coinMetricsView: CoinMetricsView

    init(viewModel: DetailViewModel, coinSummaryView: CoinLivePriceView, coinMetricsView: CoinMetricsView) {
        self.viewModel = viewModel
        self.coinLivePriceView = coinSummaryView
        self.coinMetricsView = coinMetricsView
        super.init()
    }

    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews([coinLivePriceView, segmentedControl, segmentedContainerView])
    }

    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(UIScreen.main.bounds.height + 1)
        }
        coinLivePriceView.snp.makeConstraints { make in
            make.top.width.equalTo(containerView)
            make.height.equalTo(80)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(coinLivePriceView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView).inset(16)
            make.height.equalTo(32)
        }
        segmentedContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(12)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView).inset(20)
        }

        views = [
            candleChartView,
            BaseView(),
            coinMetricsView
        ]

        views.forEach { view in
            segmentedContainerView.addSubview(view)
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            view.isHidden = true
        }

        views.first?.isHidden = false
    }

    override func configureView() {
        configureSegmentedControl()
    }

    override func configureNavigation() {
        navigationItem.leftBarButtonItem = barButton
        navigationItem.rightBarButtonItem = favoriteButton
    }

    override func bind() {
        let input = DetailViewModel.Input(
            barButtonTapped: barButton.rx.tap)
        let output = viewModel.transform(input: input)

        output.action
            .bind(with: self) { owner, action in
                switch action {
                case .pop:
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)

        output.chartEntity
            .bind(with: self) { owner, entities in
                let listEntities = entities.reversed().map { ChartListEntity(date: $0.date, price: $0.price)}
                owner.candleChartView.configureChartHostingView(with: listEntities)
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - segmented control
extension DetailViewController {
    private func configureSegmentedControl() {
        segmentedControl.items = [
            StringLiteral.Information.graph,
            StringLiteral.Information.orderBook,
            StringLiteral.Information.summary
        ]
        segmentedControl.selectionChanged = { [weak self] index in
            guard let self else { return }
            for (i, view) in views.enumerated() {
                view.isHidden = (i != index)
            }
        }
    }
}
