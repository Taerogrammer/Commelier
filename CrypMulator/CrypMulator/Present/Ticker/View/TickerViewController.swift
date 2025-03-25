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
        tickerListView.tickerListViewModel.getDataByTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        tickerListView.tickerListViewModel.disposeTimer()
    }

    override func bind() {
//        output.error
//            .bind(with: self) { owner, error in
//                owner.tickerListViewModel.disposeTimer()
//                let vc = AlertViewController()
//                vc.alertView.messageLabel.text = error.description
//                vc.delegate = owner
//                vc.modalPresentationStyle = .overFullScreen
//                owner.present(vc, animated: true)
//            }
//            .disposed(by: disposeBag)
    }

}

// MARK: - delegate
extension TickerViewController: AlertViewDismissDelegate {
    func alertViewDismiss() {
        tickerListView.tickerListViewModel.getDataByTimer()
    }
}
