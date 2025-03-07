//
//  TrendingViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxDataSources
import RxSwift

final class TrendingViewController: BaseViewController {
    private let searchBar = UISearchBar()


    override func configureHierarchy() {
        view.addSubview(searchBar)
    }

    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        configureSearchBar()
    }

    override func configureNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = "가상자산 / 심볼 검색"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    private func configureSearchBar() {
        searchBar.clipsToBounds = true
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.searchTextField.font = .systemFont(ofSize: 12)
        searchBar.setImage(UIImage(systemName: "xmark"), for: .clear, state: .normal)
        searchBar.tintColor = .customGray
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.borderColor = UIColor.customGray.cgColor
        searchBar.searchTextField.layer.cornerRadius = 16
        searchBar.searchTextField.backgroundColor = .white
    }

}
