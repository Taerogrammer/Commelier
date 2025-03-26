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
    private let tickerViewModel = TickerViewModel()
    private let disposeBag = DisposeBag()
    private lazy var tickerListView = TickerListView(
        tickerListViewModel: tickerViewModel.tickerListViewModel)

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
        navigationItem.title = StringLiteral.NavigationTitle.ticker
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tickerListView.tickerListViewModel.getDataByTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        tickerListView.tickerListViewModel.disposeTimer()
    }

    override func bind() {
        let input = TickerViewModel.Input()
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
    }

}

// MARK: - delegate
extension TickerViewController: AlertViewDismissDelegate {
    func alertViewDismiss() {
        tickerListView.tickerListViewModel.getDataByTimer()
    }
}
