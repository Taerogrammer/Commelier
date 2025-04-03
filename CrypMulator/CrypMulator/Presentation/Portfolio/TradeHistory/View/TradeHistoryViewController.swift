//
//  TransactionViewController.swift
//  CrypMulator
//
//  Created by 김태형 on 3/26/25.
//

import UIKit
import SnapKit

final class TradeHistoryViewController: BaseViewController {

    private let tableView = UITableView()
    private var data: [TradeHistoryModel] = []

    override func configureHierarchy() {
        view.addSubview(tableView)
    }

    override func configureLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        tableView.register(TradeHistoryCell.self, forCellReuseIdentifier: TradeHistoryCell.identifier)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 120

        setupData()
    }

    private func setupData() {
        data = [
            TradeHistoryModel(type: .buy, pair: "KRW-BTC", price: "1,123,123 KRW", amount: "0.0125 ETH", total: "124,532,51 KRW", date: "2024.02.20 10:45"),
            TradeHistoryModel(type: .sell, pair: "KRW-BTC", price: "1,123,123 KRW", amount: "0.0125 ETH", total: "124,532,51 KRW", date: "2024.02.20 10:45"),
            TradeHistoryModel(type: .sell, pair: "KRW-BTC", price: "1,123,123 KRW", amount: "0.0125 ETH", total: "124,532,51 KRW", date: "2024.02.20 10:45"),
            TradeHistoryModel(type: .sell, pair: "KRW-BTC", price: "1,123,123 KRW", amount: "0.0125 ETH", total: "124,532,51 KRW", date: "2024.02.20 10:45")
        ]
        tableView.reloadData()
    }
}

extension TradeHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TradeHistoryCell.identifier, for: indexPath) as? TradeHistoryCell else {
            return UITableViewCell()
        }
        cell.configure(with: data[indexPath.row])
        return cell
    }
}
