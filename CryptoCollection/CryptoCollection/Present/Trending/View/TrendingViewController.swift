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
    enum Section: CaseIterable {
        case coin
        case nft
    }

    private let searchBar = UISearchBar()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout())
    private let viewModel = TrendingViewModel()
    private let disposeBag = DisposeBag()


    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!

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
        bind()
    }

    override func configureNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = "가상자산 / 심볼 검색"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    private func bind() {
        let input = TrendingViewModel.Input(
            searchBarTapped: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)

        output.action
            .bind(with: self) { owner, action in
                owner.view.endEditing(true)
                switch action {
                case .navigateToDetail(let text):
                    print("String", text)
                    let vm = SearchViewModel(searchText: text)
                    let vc = SearchViewController(viewModel: vm)
                    vc.title = text

                    owner.navigationController?.pushViewController(vc, animated: true)

                case .showAlert:
                    print("alert")
                }
            }
            .disposed(by: disposeBag)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)

                let innerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/7), heightDimension: .fractionalHeight(1.0))
                let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerSize, subitems: [item])

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])

                let section = NSCollectionLayoutSection(group: group)

                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                return section
            }
        }

        return layout
    }

    private func configureDataSource() {
        let coinCellRegistration = UICollectionView.CellRegistration<CoinCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
            print("coinRegistration", indexPath)
        }

        let nftCellRegistration = UICollectionView.CellRegistration<NFTCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
            print("nftRegistration", indexPath)
        }

        // cellForItemAt
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let section = Section.allCases[indexPath.section]

                switch section {
                case .coin:
                    let cell = collectionView.dequeueConfiguredReusableCell(using: coinCellRegistration, for: indexPath, item: itemIdentifier)
                    print("coin Reusable Cell", indexPath)
                    return cell
                case .nft:
                    let cell = collectionView.dequeueConfiguredReusableCell(using: nftCellRegistration, for: indexPath, item: itemIdentifier)
                    print("nft Reusable Cell", indexPath)
                    return cell
                }
            })
    }

}
