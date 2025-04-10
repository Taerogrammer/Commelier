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
    private var data: [TradeHistoryEntity] = []
    private let useCase: TradeHistoryUseCaseProtocol

    init(useCase: TradeHistoryUseCaseProtocol) {
        self.useCase = useCase
        super.init()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }

    override func configureHierarchy() {
        view.addSubview(tableView)
    }

    override func configureLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        tableView.backgroundColor = SystemColor.background
        tableView.register(TradeHistoryCell.self, forCellReuseIdentifier: TradeHistoryCell.identifier)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 120
        tableView.showsVerticalScrollIndicator = false
        setupData()
    }

    private func setupData() {
        data = useCase.getTradeHistory()
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
        cell.selectionStyle = .none
        cell.configure(with: data[indexPath.row])
        return cell
    }
}
