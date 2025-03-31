//
//  CoinMetricsView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/31/25.
//

import Combine
import UIKit
import SnapKit

struct DetailInformation: Hashable {
    let title: String
    let money: String
    let date: String
}

struct DetailSection {
    let title: String
    var items: [DetailInformation]
}

final class CoinMetricsView: BaseView {
    private var viewModel: CoinMetricViewModel?
    private var cancellables = Set<AnyCancellable>()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout())
    private var dataSource: UICollectionViewDiffableDataSource<String, DetailInformation>!

    init(viewModel: CoinMetricViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

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
        collectionView.backgroundColor = SystemColor.white
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        configureDiffableDataSource()

    }

    override func bind() {
        let input = CoinMetricViewModel.Input()
        let output = viewModel?.transform(input: input)

        output?.sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                self?.applySnapshot(with: sections)
            }
            .store(in: &cancellables)
    }
}

extension CoinMetricsView {
    private func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, DetailInformation>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SymbolInfoCell.identifier,
                    for: indexPath
                ) as! SymbolInfoCell
                // TODO: - "원"을 붙일지 말지 고민
                cell.titleLabel.text = item.title
                cell.amountLabel.text = item.money
                cell.dateLabel.text = item.date

                return cell
            })

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: OldDetailCollectionHeaderView.identifier,
                for: indexPath
            ) as! OldDetailCollectionHeaderView

            header.configureTitle(with: section)
            return header
        }
    }

    private func applySnapshot(with sections: [DetailSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, DetailInformation>()
        for section in sections {
            snapshot.appendSections([section.title])
            snapshot.appendItems(section.items)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


extension CoinMetricsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? SymbolInfoCell else { return }
        cell.configureCorners(for: indexPath, in: collectionView)
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
                    widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
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
