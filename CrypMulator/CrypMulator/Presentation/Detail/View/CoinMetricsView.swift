//
//  CoinMetricsView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/31/25.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

struct DetailSection {
    let title: String
    var items: [Item]
}

struct DetailInformation: Equatable {
    let title: String
    let money: String
    let date: String
}

extension DetailSection: SectionModelType {
    typealias Item = DetailInformation

    init(original: DetailSection, items: [DetailInformation]) {
        self = original
        self.items = items
    }
}

final class CoinMetricsView: BaseView {
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout())
    private var dataSource: RxCollectionViewSectionedReloadDataSource<DetailSection>!

    override func configureHierarchy() {
        addSubview(collectionView)
    }

    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func configureView() {
        collectionView.register(SymbolInfoCell.self, forCellWithReuseIdentifier: SymbolInfoCell.identifier)
        collectionView.register(
            OldDetailCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: OldDetailCollectionHeaderView.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.isScrollEnabled = false
    }

}

// MARK: - collection view
extension CoinMetricsView {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

            switch sectionIndex {
            case 0: // 종목정보
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute((UIScreen.main.bounds.width - 32) / 2), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]

                return section
            case 1: // 투자지표
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(UIScreen.main.bounds.width - 32), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
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
extension CoinMetricsView {
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<DetailSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SymbolInfoCell.identifier, for: indexPath) as! SymbolInfoCell

                cell.titleLabel.text = item.title
                cell.amountLabel.text = item.money
                cell.dateLabel.text = item.money

                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: OldDetailCollectionHeaderView.identifier,
                    for: indexPath) as! OldDetailCollectionHeaderView

                header.configureTitle(with: dataSource[indexPath.section].title)

                /*
                header.moreButton.rx.tap
                    .bind { [weak self] _ in
                        self?.view.makeToast(
                            "준비 중입니다",
                            duration: 2.0,
                            position: .bottom)
                    }
                    .disposed(by: self?.disposeBag ?? DisposeBag())
                 */

                return header
            }
        )
    }
}
