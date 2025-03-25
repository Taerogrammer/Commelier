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
    private let viewModel = TickerViewModel()
    private var disposeBag = DisposeBag()
    let headerView = TickerHeaderView()
    let tickerTableView = UITableView()

    override func configureHierarchy() {
        addSubViews([headerView, tickerTableView])
    }

    override func configureLayout() {
        tickerTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        headerView.snp.makeConstraints { make in
            make.width.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }

    override func configureView() {
        tickerTableView.register(
            TickerTableViewCell.self,
            forCellReuseIdentifier: TickerTableViewCell.identifier)
        tickerTableView.separatorStyle = .none
        tickerTableView.rowHeight = 44
        tickerTableView.tableHeaderView = headerView
        tickerTableView.showsVerticalScrollIndicator = false
    }


}
