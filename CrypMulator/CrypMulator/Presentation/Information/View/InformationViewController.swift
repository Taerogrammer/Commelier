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

struct InformationSection {
    let title: String
    let updated: String?
    var items: [Item]
}

enum InformationItem {
    case coins(CoinRankingViewData)
    case holding(HoldingEntity)
}

struct CoinRankingViewData: Equatable {
    let id: String
    let rank: String
    let imageURL: String
    let symbol: String
    let name: String
    let rate: Double
}

extension InformationSection: SectionModelType {
    typealias Item = InformationItem

    init(original: InformationSection, items: [InformationItem]) {
        self = original
        self.items = items
    }
}

final class InformationViewController: BaseViewController {

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout())
    private let viewModel = InformationViewModel(repository: HoldingRepository())
    private var disposeBag = DisposeBag()
    private var dataSource: RxCollectionViewSectionedReloadDataSource<InformationSection>!

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
        collectionView.register(FavoriteCoinCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCoinCollectionViewCell.identifier)
        collectionView.register(InformationCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InformationCollectionHeaderView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        configureDataSource()
    }

    override func configureNavigation() {
        navigationItem.title = StringLiteral.NavigationTitle.information
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
        let input = InformationViewModel.Input()
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
//                    let vm = OldDetailViewModel(id: coinData.id)
//                    let vc = OldDetailViewController(viewModel: vm)
//
//                    owner.navigationController?.pushViewController(vc, animated: true)
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
extension InformationViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

            switch sectionIndex {
            case 0: // 인기 검색어
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

            case 1: // 보유 목록
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(56))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize,subitems: [item])

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
extension InformationViewController {
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<InformationSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch item {
                case .coins(let coin):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinCollectionViewCell.identifier, for: indexPath) as! CoinCollectionViewCell
                    cell.configureCell(with: coin)

                    return cell

                case .holding(let coin):
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: FavoriteCoinCollectionViewCell.identifier,
                        for: indexPath
                    ) as! FavoriteCoinCollectionViewCell

                    cell.configureCell(with: coin)

                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                    let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: InformationCollectionHeaderView.identifier,
                        for: indexPath) as! InformationCollectionHeaderView
                header.configureTitle(with: dataSource[indexPath.section].title, updateTime: dataSource[indexPath.section].updated)

                return header
            }
        )
    }
}
