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
    private let chartView = OldDetailChartView()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews([chartView])
    }

    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        chartView.snp.makeConstraints { make in
            make.top.width.equalTo(containerView)
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
//                print("============", listEntities)
                owner.chartView.configureChartHostingView(with: listEntities)
            }
            .disposed(by: disposeBag)
    }


}
