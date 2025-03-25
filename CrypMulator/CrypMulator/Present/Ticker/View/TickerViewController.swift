//
//  TickerViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class TickerViewController: BaseViewController {
    private let viewModel = TickerListViewModel()
    private var disposeBag = DisposeBag()

    private let tickerListView = TickerListView()

    override func configureHierarchy() {
        view.addSubview(tickerListView)
    }

    override func configureLayout() {
        tickerListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {

    }

    override func configureNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = "거래소"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getDataByTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.disposeTimer()
    }

    override func bind() {
        let input = TickerListViewModel.Input(
            priceTapped: tickerListView.headerView.priceButton.rx.tapGesture(),
            changedPriceTapped: tickerListView.headerView.changedPriceButton.rx.tapGesture(),
            accTapped: tickerListView.headerView.accButton.rx.tapGesture()
        )
        let output = viewModel.transform(input: input)

        output.data
            .bind(to:tickerListView.tickerTableView.rx.items(
                cellIdentifier: TickerTableViewCell.identifier,
                cellType: TickerTableViewCell.self)) { index, element, cell in
                    cell.name.text = element.market
                    cell.price.text = element.trade_price_description
                    cell.changeRate.text = element.signed_change_rate_description
                    cell.changePrice.text = element.signed_change_price_description
                    cell.tradePrice.text = element.acc_trade_price_24h_description
                    cell.updateColor(number: element.signed_change_rate)
                }
                .disposed(by: disposeBag)

        output.buttonStatus
            .subscribe(with: self) { owner, status in
                owner.tickerListView.headerView.priceButton.buttonStatus(status: status.price)
                owner.tickerListView.headerView.changedPriceButton.buttonStatus(status: status.changedPrice)
                owner.tickerListView.headerView.accButton.buttonStatus(status: status.acc)
            }
            .disposed(by: disposeBag)

        output.error
            .bind(with: self) { owner, error in
                owner.viewModel.disposeTimer()
                let vc = AlertViewController()
                vc.alertView.messageLabel.text = error.description
                vc.delegate = owner
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - delegate
extension TickerViewController: AlertViewDismissDelegate {
    func alertViewDismiss() {
        viewModel.getDataByTimer()
    }
}
