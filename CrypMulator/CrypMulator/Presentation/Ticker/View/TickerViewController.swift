//
//  TickerViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import Combine
import UIKit
import SnapKit
import RxCocoa
import RxGesture
import RxSwift

final class TickerViewController: BaseViewController {
    private let tickerViewModel: TickerViewModel
    private let summaryViewModel: PortfolioSummaryViewModel

    private let disposeBag = DisposeBag()
    private var cancellables = Set<AnyCancellable>()
    private lazy var tickerListView = TickerListView(
        tickerListViewModel: tickerViewModel.tickerListViewModel)

    init(tickerViewModel: TickerViewModel) {
        self.tickerViewModel = tickerViewModel
        self.summaryViewModel = PortfolioSummaryViewModel(
            portfolioUseCase: tickerViewModel.portfolioUseCase,
            webSocket: tickerViewModel.webSocket
        )
        super.init()
    }

    override func configureHierarchy() {
        view.addSubview(tickerListView)
    }

    override func configureLayout() {
        tickerListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        let repo = ChargeRepository()
        repo.getFileURL()
    }

    override func configureNavigation() {
        navigationItem.title = StringLiteral.NavigationTitle.ticker
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tickerListView.tickerListViewModel.getDataByTimer()
        summaryViewModel.connectWebSocketAndSendMarkets()
    }

    override func viewWillDisappear(_ animated: Bool) {
        tickerListView.tickerListViewModel.disposeTimer()
    }

    override func bind() {
        /// listViewModel
        let listInput = TickerListViewModel.Input(
            priceTapped: tickerListView.headerView.priceButton.rx.tapGesture(),
            changedPriceTapped: tickerListView.headerView.changedPriceButton.rx.tapGesture(),
            accTapped: tickerListView.headerView.accButton.rx.tapGesture(),
            selectedItem: tickerListView.tickerTableView.rx.modelSelected(UpbitMarketEntity.self).asObservable()
        )
        let listOutput = tickerViewModel.tickerListViewModel.transform(input: listInput)

        tickerListView.bindViewModelOutput(listOutput)

        /// TickerViewModel
        let input = TickerViewModel.Input(listInput: listInput)
        let output = tickerViewModel.transform(input: input)

        output.error
            .bind(with: self) { owner, error in
                owner.tickerViewModel.tickerListViewModel.disposeTimer()
                let vc = AlertViewController()
                vc.alertView.messageLabel.text = error.description
                vc.delegate = owner
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
                print("error", error)
            }
            .disposed(by: disposeBag)

        output.selectedItem
            .subscribe(with: self) { owner, entity in
                let market = entity.market
                let vc = DetailFactory.make(with: market)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        /// PortfolioSummaryViewModel
        let summaryOutput = summaryViewModel.transform(input: .init())

        summaryOutput.snapshot
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                self?.tickerListView.headerView.updatePortfolioSummary(from: snapshot)
            }
            .store(in: &cancellables)


    }

}

// MARK: - delegate
extension TickerViewController: AlertViewDismissDelegate {
    func alertViewDismiss() {
        tickerListView.tickerListViewModel.getDataByTimer()
    }
}
