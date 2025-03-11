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
import Toast

import RealmSwift

final class SearchViewController: BaseViewController {
    private let viewModel: SearchViewModel
    private var disposeBag = DisposeBag()
    private let barButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.left"),
        style: .plain,
        target: nil,
        action: nil)
    let searchBar = UISearchBar()
    private let segmentedControl = UnderlineSegmentedControl(items: ["코인", "NFT", "거래소"])
    private let childView = BaseView()
    private let segCoinViewController = SegCoinViewController()
    private let segNFTViewController = SegNFTViewController()
    private let segTickerViewController = SegTickerViewController()
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal)
    private var blueStyle = ToastStyle()
    private var redStyle = ToastStyle()
    var segViewControllers: [BaseViewController] {
        [segCoinViewController, segNFTViewController, segTickerViewController]
    }
    var currentPage: Int = 0 {
      didSet {
        print(oldValue, self.currentPage)
        let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
        self.pageViewController.setViewControllers(
          [segViewControllers[self.currentPage]],
          direction: direction,
          animated: true,
          completion: nil
        )
      }
    }

    ///
    private let favoriteButtonTapped = PublishSubject<CoinData>()
    private let realm = try! Realm()
    ///

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
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.customGray], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .font: UIFont.boldSystemFont(ofSize: 12)
        ], for: .selected)
        segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedControl) 

        pageViewController.delegate = self
        pageViewController.dataSource = self

        segCoinViewController.coinCollectionView.register(SearchCoinCollectionViewCell.self, forCellWithReuseIdentifier: SearchCoinCollectionViewCell.identifier)
        segCoinViewController.coinCollectionView.keyboardDismissMode = .onDrag
        configureSearchBar()

        blueStyle.messageColor = UIColor.customBlue
        redStyle.messageColor = UIColor.customRed
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

        // TODO: cell VM 분리
        output.data
            .bind(to: segCoinViewController.coinCollectionView.rx.items(
                cellIdentifier: SearchCoinCollectionViewCell.identifier,
                cellType: SearchCoinCollectionViewCell.self)) { index, element, cell in
                    cell.configureCell(with: element)
                    /// Realm
                    cell.favoriteButton.rx.tapGesture()
                        .when(.recognized)
                        .subscribe(with: self) { owner, _ in
                            let realm = owner.realm

                            if let deletedItem = realm.objects(FavoriteCoin.self)
                                .filter("id == %@", element.id)
                                .first {
                                // Realm Delete
                                do {
                                    try realm.write {
                                        realm.delete(deletedItem)
                                        owner.view.makeToast(
                                            "즐겨찾기에서 제거되었습니다",
                                            duration: 2.0,
                                            position: .bottom,
                                            style: owner.redStyle)
                                    }
                                } catch {
                                    print("realm Deleted Error", error)
                                }
                            } else {
                                do {
                                    try realm.write {
                                        let favoriteData = FavoriteCoin(
                                            id: element.id,
                                            symbol: element.symbol,
                                            image: element.thumb)
                                        realm.add(favoriteData)
                                        owner.view.makeToast(
                                            "즐겨찾기에 추가되었습니다",
                                            duration: 2.0,
                                            position: .bottom,
                                            style: owner.blueStyle)
                                    }
                                } catch {
                                    print("Realm Create Failed", error)
                                }
                            }
                            // 셀 버튼 업데이트 메서드
                            cell.updateFavoriteButton(id: element.id)
                        }
                        .disposed(by: cell.disposeBag)
                    ///
                }
                .disposed(by: disposeBag)

        segCoinViewController.coinCollectionView.rx.itemSelected
            .withLatestFrom(output.data) { indexPath, data in
                data[indexPath.item]
            }
            .bind(with: self) { owner, data in
                let vm = DetailViewModel(id: data.id)
                let vc = DetailViewController(viewModel: vm)

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
        searchBar.searchTextField.textColor = UIColor.customBlack
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
