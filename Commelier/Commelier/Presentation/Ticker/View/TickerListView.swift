//
//  TickerListView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/25/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class TickerListView: BaseView {
    private var disposeBag = DisposeBag()
    let tickerListViewModel: TickerListViewModel
    let headerView = TickerListHeaderView()
    let tickerTableView = UITableView()

    init(tickerListViewModel: TickerListViewModel) {
        self.tickerListViewModel = tickerListViewModel
        super.init(frame: .zero)
    }

    override func configureHierarchy() {
        addSubviews([headerView, tickerTableView])
    }

    override func configureLayout() {
        headerView.snp.makeConstraints { make in
            make.width.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(96)
        }
        tickerTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        tickerTableView.backgroundColor = SystemColor.background
        tickerTableView.register(
            TickerTableViewCell.self,
            forCellReuseIdentifier: TickerTableViewCell.identifier)
        tickerTableView.separatorStyle = .none
        tickerTableView.rowHeight = 44
        tickerTableView.tableHeaderView = headerView
        tickerTableView.showsVerticalScrollIndicator = false
    }
}

// MARK: - bind
extension TickerListView {
    func bindViewModelOutput(_ output: TickerListViewModel.Output) {
        output.data
            .bind(to: tickerTableView.rx.items(
                cellIdentifier: TickerTableViewCell.identifier,
                cellType: TickerTableViewCell.self)) { index, element, cell in
                    cell.selectionStyle = .none
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
                owner.headerView.priceButton.buttonStatus(status: status.price)
                owner.headerView.changedPriceButton.buttonStatus(status: status.changedPrice)
                owner.headerView.accButton.buttonStatus(status: status.acc)
            }
            .disposed(by: disposeBag)
    }
}
