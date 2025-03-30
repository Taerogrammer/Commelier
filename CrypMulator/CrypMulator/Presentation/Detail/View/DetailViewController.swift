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

    init(viewModel: DetailViewModel, coinSummaryView: CoinLivePriceView) {
        self.viewModel = viewModel
        self.coinLivePriceView = coinSummaryView
        super.init()
    }

    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews([coinLivePriceView, candleChartView])
    }

    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        coinLivePriceView.snp.makeConstraints { make in
            make.top.width.equalTo(containerView)
            make.height.equalTo(80)
        }
        candleChartView.snp.makeConstraints { make in
            make.width.equalTo(containerView)
            make.top.equalTo(coinLivePriceView.snp.bottom).inset(12)
            make.height.equalTo(400)
            make.bottom.equalTo(containerView).inset(20)
        }
    }

    override func configureView() {

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
