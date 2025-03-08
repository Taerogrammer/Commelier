//
//  SearchViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Toast

final class SearchViewController: BaseViewController {
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    let searchBar = UISearchBar()
    private let barButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.left"),
        style: .plain,
        target: nil,
        action: nil)

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func configureView() {
        bind()
        configureSearchBar()
    }

    override func configureNavigation() {
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = barButton
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }

    private func configureSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.borderStyle = .none
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.searchTextField.font = .systemFont(ofSize: 12)
        searchBar.searchTextField.textColor = UIColor.customBlack
    }

    private func bind() {
        let input = SearchViewModel.Input(
            barButtonTapped: barButton.rx.tap)
        let output = viewModel.transform(input: input)

        output.action
            .bind(with: self) { owner, action in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

    }

}


