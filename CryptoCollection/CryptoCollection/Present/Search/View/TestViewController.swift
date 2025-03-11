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


final class TestViewController: BaseViewController {
    private let searchBar = UISearchBar()
    private let segmentedControl = UnderlineSegmentedControl(items: ["코인", "NFT", "거래소"])
    private let childView = BaseView()
    private let segCoinViewController = BaseViewController()
    private let segNFTViewController = BaseViewController()
    private let segTickerViewController = BaseViewController()
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal)
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

    override func configureHierarchy() {
        view.addSubview(segmentedControl)
        view.addSubview(pageViewController.view)

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
        segCoinViewController.view.backgroundColor = .red
        segNFTViewController.view.backgroundColor = .blue
        segTickerViewController.view.backgroundColor = .green

        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.customGray], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .font: UIFont.boldSystemFont(ofSize: 12)
        ], for: .selected)

        segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedControl)

        pageViewController.delegate = self
        pageViewController.dataSource = self

    }

    @objc private func changeValue(control: UISegmentedControl) {
      // 코드로 값을 변경하면 해당 메소드 호출 x
      self.currentPage = control.selectedSegmentIndex
    }


}

// MARK: - page view controller
extension TestViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
