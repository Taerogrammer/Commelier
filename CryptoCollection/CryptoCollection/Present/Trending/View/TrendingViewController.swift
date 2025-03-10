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

struct TrendingSection {
    let title: String
    let updated: String?
    var items: [Item]
}

enum TrendingItem {
    case coins(TrendingCoin)
    case nfts(TrendingNFT)
}

struct TrendingCoin: Equatable {
    let rank: String
    let imageURL: String
    let symbol: String
    let name: String
    let rate: Double
}

struct TrendingNFT: Equatable {
    let imageURL: String
    let name: String
    let floorPrice: String
    let floorPriceChange: String
}

extension TrendingSection: SectionModelType {
    typealias Item = TrendingItem

    init(original: TrendingSection, items: [TrendingItem]) {
        self = original
        self.items = items
    }
}

final class TrendingViewController: BaseViewController {

    private let searchBar = UISearchBar()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout())
    private let viewModel = TrendingViewModel()
    private let disposeBag = DisposeBag()

    private var dataSource: RxCollectionViewSectionedReloadDataSource<TrendingSection>!

    override func configureHierarchy() {
        [searchBar, collectionView].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        configureSearchBar()
        collectionView.register(CoinCollectionViewCell.self, forCellWithReuseIdentifier: CoinCollectionViewCell.identifier)
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
        collectionView.register(TrendingCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrendingCollectionHeaderView.identifier)
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        configureDataSource()
        hideKeyBoardWhenTappedScreen()
    }

    override func configureNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = "가상자산 / 심볼 검색"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    override func bind() {
        let input = TrendingViewModel.Input(
            searchBarTapped: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)

        output.action
            .bind(with: self) { owner, action in
                owner.view.endEditing(true)
                switch action {
                case .navigateToDetail(let text):
                    let vm = SearchViewModel(searchText: text)
                    let vc = SearchViewController(viewModel: vm)
                    vc.searchBar.text = text

                    owner.navigationController?.pushViewController(vc, animated: true)

                case .showAlert:
                    print("alert")
                }
            }
            .disposed(by: disposeBag)

        output.sectionResult
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
}

// MARK: - configure view
extension TrendingViewController {
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
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1 / 8))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)

                let innerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2), heightDimension: .fractionalHeight(1.0))
                let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerSize, subitems: [item])

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44 * 8))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
                section.boundarySupplementaryItems = [header]

                return section

            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(400), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
                section.boundarySupplementaryItems = [header]

                return section

            default:
                return nil
            }
        }

        return layout
    }

}

// MARK: - Data Source
extension TrendingViewController {
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<TrendingSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch item {
                case .coins(let coin):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinCollectionViewCell.identifier, for: indexPath) as! CoinCollectionViewCell
                    cell.configureCell(with: coin)

                    return cell

                case .nfts(let nft):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as! NFTCollectionViewCell
                    cell.configureCell(with: nft)

                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                    let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: TrendingCollectionHeaderView.identifier,
                        for: indexPath) as! TrendingCollectionHeaderView
                header.configureTitle(with: dataSource[indexPath.section].title, updateTime: dataSource[indexPath.section].updated)

                return header
            }
        )
    }
}

// MARK: - seach bar
extension TrendingViewController {
    private func hideKeyBoardWhenTappedScreen() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func tapHandler() {
        searchBar.endEditing(true)
    }
}
