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
    private let segment = UISegmentedControl()
    private let grayLineView = BaseView()
    private let underLineView = BaseView()
    private let segCoinView = SegCoinView()
    private let segNFTView = SegNFTView()
    private let segTickerView = SegTickerView()

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func configureHierarchy() {
        [segment, grayLineView, underLineView, segCoinView, segNFTView, segTickerView].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        segment.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom)
            make.width.equalTo(segment).dividedBy(3)
            make.height.equalTo(4)
        }
        grayLineView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(2)
        }
        segCoinView.snp.makeConstraints { make in
            make.top.equalTo(grayLineView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        segNFTView.snp.makeConstraints { make in
            make.top.equalTo(grayLineView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        segTickerView.snp.makeConstraints { make in
            make.top.equalTo(grayLineView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        underLineView.backgroundColor = UIColor.black
        grayLineView.backgroundColor = UIColor.customGray
        segCoinView.coinCollectionView.register(SearchCoinCollectionViewCell.self, forCellWithReuseIdentifier: SearchCoinCollectionViewCell.identifier)
        segCoinView.coinCollectionView.keyboardDismissMode = .onDrag
        bind()
        configureSearchBar()
        configureSegmentControl()
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

    private func configureSegmentControl() {
        segment.insertSegment(withTitle: "코인", at: 0, animated: true)
        segment.insertSegment(withTitle: "NFT", at: 1, animated: true)
        segment.insertSegment(withTitle: "거래소", at: 2, animated: true)
        segment.selectedSegmentIndex = 0
        segCoinView.isHidden = false
        segNFTView.isHidden = true
        segTickerView.isHidden = true
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.customGray
        ], for: .normal)
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.customBlack
        ], for: .selected)
        segment.selectedSegmentTintColor = .clear
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        segment.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)

    }

    private func bind() {
        let input = SearchViewModel.Input(
            searchBarTapped: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty,
            barButtonTapped: barButton.rx.tap,
            itemSelectedTapped: segCoinView.coinCollectionView.rx.itemSelected)
        let output = viewModel.transform(input: input)


        searchBar.rx.searchButtonClicked
            .subscribe(with: self) { owner, _ in
                owner.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)

        output.action
            .bind(with: self) { owner, action in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        output.data
            .bind(to: segCoinView.coinCollectionView.rx.items(
                cellIdentifier: SearchCoinCollectionViewCell.identifier,
                cellType: SearchCoinCollectionViewCell.self)) { index, element, cell in
                    cell.configureCell(with: element)
                }
                .disposed(by: disposeBag)

        segCoinView.coinCollectionView.rx.itemSelected
            .withLatestFrom(output.data) { indexPath, data in
                data[indexPath.item].id
            }
            .bind(with: self) { owner, id in
                let vm = DetailViewModel(id: id)
                let vc = DetailViewController(viewModel: vm)

                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - @objc
extension SearchViewController {
    @objc private func changeUnderLinePosition(_ segment: UISegmentedControl) {
        let segWidth = segment.frame.width / 3
        let xPosition = segment.frame.origin.x + (segWidth * CGFloat(segment.selectedSegmentIndex))

        UIView.animate(withDuration: 0.2) {
            self.underLineView.frame.origin.x = xPosition
        }

        switch segment.selectedSegmentIndex {
        case 0:
            segCoinView.isHidden = false
            segNFTView.isHidden = true
            segTickerView.isHidden = true
        case 1:
            segCoinView.isHidden = true
            segNFTView.isHidden = false
            segTickerView.isHidden = true
        case 2:
            segCoinView.isHidden = true
            segNFTView.isHidden = true
            segTickerView.isHidden = false
        default:
            segCoinView.isHidden = false
            segNFTView.isHidden = true
            segTickerView.isHidden = true
        }
    }
}
