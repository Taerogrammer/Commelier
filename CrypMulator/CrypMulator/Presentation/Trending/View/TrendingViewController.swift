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
}

struct TrendingCoin: Equatable {
    let id: String
    let rank: String
    let imageURL: String
    let symbol: String
    let name: String
    let rate: Double
}

extension TrendingSection: SectionModelType {
    typealias Item = TrendingItem

    init(original: TrendingSection, items: [TrendingItem]) {
        self = original
        self.items = items
    }
}

final class TrendingViewController: BaseViewController {

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout())
    private let viewModel = TrendingViewModel()
    private var disposeBag = DisposeBag()
    private var dataSource: RxCollectionViewSectionedReloadDataSource<TrendingSection>!

    override func configureHierarchy() {
        view.addSubview(collectionView)
    }

    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        collectionView.register(CoinCollectionViewCell.self, forCellWithReuseIdentifier: CoinCollectionViewCell.identifier)
        collectionView.register(TrendingCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrendingCollectionHeaderView.identifier)
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        configureDataSource()
    }

    override func configureNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = StringLiteral.NavigationTitle.information
        titleLabel.font = .boldSystemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getDataByTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.disposeTimer()
    }

    override func bind() {
        disposeBag = DisposeBag()
        let input = TrendingViewModel.Input()
        let output = viewModel.transform(input: input)

        output.sectionResult
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .withLatestFrom(output.sectionResult) { indexPath, data in
                data[indexPath.section].items[indexPath.item]
            }
            .asObservable()
            .bind(with: self) { owner, item in
                if case .coins(let coinData) = item {
                    let vm = DetailViewModel(id: coinData.id)
                    let vc = DetailViewController(viewModel: vm)

                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)

        output.error
            .bind(with: self) { owner, error in
                let vc = AlertViewController()
                vc.alertView.messageLabel.text = error.description
                vc.modalPresentationStyle = .overFullScreen
                vc.alertView.retryButton.rx.tap
                    .bind(with: owner) { owner, _ in
                        owner.bind()
                        vc.dismiss(animated: true)
                    }
                    .disposed(by: owner.disposeBag)
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - configure view
extension TrendingViewController {
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
