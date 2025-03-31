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

    private let scrollView = UIScrollView()
    private let containerView = BaseView()

    private let coinLivePriceView: CoinLivePriceView
    private let candleChartView = CandleChartView()

    private let segmentedControl = CustomSegmentedControl()
    private let segmentedContainerView = BaseView()

    private var views: [BaseView] = []

    init(viewModel: DetailViewModel, coinSummaryView: CoinLivePriceView) {
        self.viewModel = viewModel
        self.coinLivePriceView = coinSummaryView
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
            BaseView()
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

    override func bind() {
        let input = DetailViewModel.Input()
        let output = viewModel.transform(input: input)

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
        segmentedControl.items = ["그래프", "1주", "1개월"]
        segmentedControl.selectionChanged = { [weak self] index in
            guard let self else { return }
            for (i, view) in views.enumerated() {
                view.isHidden = (i != index)
            }
        }
    }
}
