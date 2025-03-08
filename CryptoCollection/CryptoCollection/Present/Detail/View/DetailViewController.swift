//
//  DetailViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import Kingfisher
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

struct Section {
    let name: String
    var items: [Item]
}

struct Information: Equatable {
    let title: String
    let money: String
    let date: String
}

extension Section: SectionModelType {
    typealias Item = Information

    init(original: Section, items: [Information]) {
        self = original
        self.items = items
    }
}

final class DetailViewController: BaseViewController {
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    private let titleView = DetailTitleView()
    private let barButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.left"),
        style: .plain,
        target: nil,
        action: nil)
    private let scrollView = UIScrollView()
    private let containerView = BaseView()
    private let chartView = DetailChartView()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout())

    private var dataSource: RxCollectionViewSectionedReloadDataSource<Section>!


    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(chartView)
        containerView.addSubview(collectionView)
    }

    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        chartView.snp.makeConstraints { make in
            make.top.width.equalTo(containerView)
            make.height.equalTo(400)
        }
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(containerView)
            make.top.equalTo(chartView.snp.bottom).offset(8)
            make.height.equalTo(360)
            make.bottom.equalTo(containerView).inset(20)
        }
    }

    override func configureView() {
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
        scrollView.showsVerticalScrollIndicator = false
        configureDataSource()
        bind()
    }

    override func configureNavigation() {
        navigationItem.leftBarButtonItem = barButton
    }

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private func bind() {
        let input = DetailViewModel.Input(
            barButtonTapped: barButton.rx.tap)
        let output = viewModel.transform(input: input)

        output.action
            .bind(with: self) { owner, action in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)


        output.data
            .withLatestFrom(output.data)
            .bind(with: self) { owner, value in
                owner.titleView.image.kf.setImage(with: URL(string: value.first!.image))
                owner.titleView.id.text = value.first?.symbol.uppercased()
                owner.navigationItem.titleView = owner.titleView
            }
            .disposed(by: disposeBag)

        output.data
            .bind(with: self) { owner, value in
                print("value", value)
            }
            .disposed(by: disposeBag)

        let dummyData = Observable.just([
            Section(name: "종목정보", items: [
                Information(title: "24시간 고가", money: "$123,123,123", date: ""),
                Information(title: "24시간 저가", money: "$123,123,123", date: ""),
                Information(title: "역대 최고가", money: "$123,123,123,123", date: "2025-03-08"),
                Information(title: "역대 최저가", money: "$123,123", date: "2025-03-08")
            ]),
            Section(name: "투자지표", items: [
                Information(title: "시가총액", money: "$2,123,123,123,123,123", date: ""),
                Information(title: "완전 희석 가치(FDV)", money: "$2,123,123,123,123,123", date: "-"),
                Information(title: "AAA", money: "%215,512,512,512,512", date: ""),
                Information(title: "QQQQQ", money: "2.1%", date: "")
            ])
        ])

        dummyData
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
}

// MARK: - collection view
extension DetailViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0: // 종목정보
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)

                return section
            case 1: // 투자지표
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)

                return section
            default:
                return nil
            }
        }

        return layout
    }
}

// MARK: - Data Source
extension DetailViewController {
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<Section>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier, for: indexPath) as! DetailCollectionViewCell

                cell.title.text = item.title
                cell.money.text = item.money
                cell.date.text = item.date

                return cell
            }
        )
    }
}
