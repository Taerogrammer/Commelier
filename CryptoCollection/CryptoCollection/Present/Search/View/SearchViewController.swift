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
    private let searchBar = UISearchBar()

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func configureView() {
    }

    override func configureNavigation() {
        navigationItem.titleView = searchBar
        let image = UIImage(systemName: "arrow.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(popViewController))
    }

    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    private func configureSearchBar() {

    }

}
