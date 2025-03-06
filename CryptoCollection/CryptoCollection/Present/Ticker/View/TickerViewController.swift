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
    private let tableView = UITableView()
    private let viewModel = TickerViewModel()
    private var disposeBag = DisposeBag()

    override func configureHierarchy() {
        view.addSubview(tableView)
    }

    override func configureLayout() {
        tableView.snp.makeConstraints { make in
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

    override func bind() {
        let output = viewModel.transform(input: TickerViewModel.Input())

        output.data
            .subscribe(with: self) { owner, value in
                print("값", value)
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 타이머 다시 시작
        print(#function)

    }

    override func viewWillDisappear(_ animated: Bool) {
        // 타이머 해제
        print(#function)
    }

}
