//
//  TestViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/11/25.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit

final class SearchViewController: BaseViewController {
    private let viewModel: SearchViewModel
    private var disposeBag = DisposeBag()
    private let barButton = UIBarButtonItem(
        image: SystemIcon.arrowLeft,
        style: .plain,
        target: nil,
        action: nil)
    let searchBar = UISearchBar()
    private let segmentedControl = UnderlineSegmentedControl(items: ["코인", "NFT", "거래소"])
    private let segCoinViewController = SegCoinViewController()
    private let segNFTViewController = SegNFTViewController()
    private let segTickerViewController = SegTickerViewController()
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal)
    var segViewControllers: [BaseViewController] {
        [segCoinViewController, segNFTViewController, segTickerViewController]
    }
    var currentPage: Int = 0 {
      didSet {
        let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
        self.pageViewController.setViewControllers(
          [segViewControllers[self.currentPage]],
          direction: direction,
          animated: true,
          completion: nil
        )
      }
    }

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func configureHierarchy() {
        [segmentedControl, pageViewController.view].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        pageViewController.view.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.top.equalTo(segmentedControl.snp.bottom).offset(4)
        }
    }

    override func configureView() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.gray], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .font: UIFont.boldSystemFont(ofSize: 12)
        ], for: .selected)
        segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedControl) 

        pageViewController.delegate = self
        pageViewController.dataSource = self

        segCoinViewController.coinCollectionView.register(FavoriteCoinCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCoinCollectionViewCell.identifier)
        segCoinViewController.coinCollectionView.keyboardDismissMode = .onDrag
        configureSearchBar()
    }

    override func configureNavigation() {
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = barButton
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segCoinViewController.coinCollectionView.reloadData()
    }

    override func bind() {
        disposeBag = DisposeBag()

        let input = SearchViewModel.Input(
            searchBarTapped: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty,
            barButtonTapped: barButton.rx.tap,
            itemSelectedTapped: segCoinViewController.coinCollectionView.rx.itemSelected)
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

        output.data
            .bind(to: segCoinViewController.coinCollectionView.rx.items(
                cellIdentifier: FavoriteCoinCollectionViewCell.identifier,
                cellType: FavoriteCoinCollectionViewCell.self)) { index, element, cell in
                    cell.configureCell(with: element)
                    cell.bind(with: SearchCoinCollectionCellViewModel(coinData: element))
                    cell.updateFavoriteButton(id: element.id)
                }
                .disposed(by: disposeBag)

        segCoinViewController.coinCollectionView.rx.itemSelected
            .withLatestFrom(output.data) { indexPath, data in
                data[indexPath.item]
            }
            .bind(with: self) { owner, data in
                let vm = OldDetailViewModel(id: data.id)
                let vc = OldDetailViewController(viewModel: vm)

                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - configure view
extension SearchViewController {
    private func configureSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.borderStyle = .none
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.searchTextField.font = .systemFont(ofSize: 12)
        searchBar.searchTextField.textColor = SystemColor.black
    }
}

// MARK: - @objc
extension SearchViewController {
    @objc private func changeValue(control: UISegmentedControl) {
        print(#function)
      self.currentPage = control.selectedSegmentIndex
    }
}

// MARK: - page view controller
extension SearchViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
      guard
        let index = self.segViewControllers.firstIndex(of: viewController as! BaseViewController),
        index - 1 >= 0
      else { return nil }
      return self.segViewControllers[index - 1]
    }
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
      guard
        let index = self.segViewControllers.firstIndex(of: viewController as! BaseViewController),
        index + 1 < self.segViewControllers.count
      else { return nil }
      return self.segViewControllers[index + 1]
    }
    func pageViewController(
      _ pageViewController: UIPageViewController,
      didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController],
      transitionCompleted completed: Bool
    ) {
      guard
        let viewController = pageViewController.viewControllers?[0],
        let index = self.segViewControllers.firstIndex(of: viewController as! BaseViewController)
      else { return }
      self.currentPage = index
      self.segmentedControl.selectedSegmentIndex = index
    }
}
